import ApplicationServices
import AppKit
// axpress <bundle-id> <menu item title>: opens the extras menu item and presses the named item.
let pid = NSRunningApplication.runningApplications(withBundleIdentifier: CommandLine.arguments[1]).first!.processIdentifier
let want = CommandLine.arguments[2]
func attr(_ e: AXUIElement, _ k: String) -> AnyObject? { var v: AnyObject?; AXUIElementCopyAttributeValue(e, k as CFString, &v); return v }
func kids(_ e: AXUIElement) -> [AXUIElement] { (attr(e, kAXChildrenAttribute) as? [AXUIElement]) ?? [] }
let bar = attr(AXUIElementCreateApplication(pid), "AXExtrasMenuBar") as! AXUIElement
let item = kids(bar)[0]
AXUIElementPerformAction(item, kAXPressAction as CFString)
usleep(400_000)
for m in kids(item) { for i in kids(m) where (attr(i, kAXTitleAttribute) as? String) == want {
    print("press", want, AXUIElementPerformAction(i, kAXPressAction as CFString).rawValue); exit(0) } }
print("not found"); AXUIElementPerformAction(item, kAXCancelAction as CFString)
