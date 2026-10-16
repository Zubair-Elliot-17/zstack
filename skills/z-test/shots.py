"""z-test UI checks: full-page shots at 1440/390/320 in Chromium + WebKit, console errors, phone overflow.

Usage: ~/.claude/skills/repo-video/.venv/bin/python ~/.claude/skills/z-test/shots.py <url> <out-dir>
Exits 1 if any page has console errors, page errors or horizontal overflow.
"""
import sys
from pathlib import Path
from playwright.sync_api import sync_playwright

WIDTHS = {"desktop": (1440, 900), "phone": (390, 844), "small": (320, 640)}


def main(url: str, out: Path) -> int:
    out.mkdir(parents=True, exist_ok=True)
    problems = []
    with sync_playwright() as p:
        for engine in (p.chromium, p.webkit):
            browser = engine.launch()
            for name, (w, h) in WIDTHS.items():
                page = browser.new_page(viewport={"width": w, "height": h}, is_mobile=w < 800 and engine.name == "chromium")
                errors = []
                page.on("console", lambda m, e=errors: m.type == "error" and e.append(m.text))
                page.on("pageerror", lambda x, e=errors: e.append(str(x)))
                page.goto(url, wait_until="networkidle")
                # scroll through so scroll-triggered sections render before the shot
                height = page.evaluate("document.documentElement.scrollHeight")
                for y in range(0, height, h // 2):
                    page.evaluate(f"window.scrollTo(0, {y})")
                    page.wait_for_timeout(120)
                page.evaluate("window.scrollTo(0, 0)")
                page.wait_for_timeout(300)
                shot = out / f"{engine.name}-{name}.png"
                page.screenshot(path=str(shot), full_page=True)
                overflow = page.evaluate("document.documentElement.scrollWidth - window.innerWidth")
                tag = f"{engine.name} {name} {w}px"
                if errors:
                    problems.append(f"{tag}: {len(errors)} console/page errors: {errors[:3]}")
                if overflow > 0:
                    problems.append(f"{tag}: horizontal overflow {overflow}px")
                print(f"{tag}: {shot} errors={len(errors)} overflow={overflow}")
                page.close()
            browser.close()
    for line in problems:
        print("PROBLEM", line)
    return 1 if problems else 0


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    sys.exit(main(sys.argv[1], Path(sys.argv[2])))
