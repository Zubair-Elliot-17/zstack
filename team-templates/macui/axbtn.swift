import ApplicationServices
import AppKit
// axbtn <bundle-id> <button title>: AXPress the first window button with that description/title.
let pid = NSRunningApplication.runningApplications(withBundleIdentifier: CommandLine.arguments[1]).first!.processIdentifier
let want = CommandLine.arguments[2]
func attr(_ e: AXUIElement, _ k: String) -> AnyObject? { var v: AnyObject?; AXUIElementCopyAttributeValue(e, k as CFString, &v); return v }
func kids(_ e: AXUIElement) -> [AXUIElement] { (attr(e, kAXChildrenAttribute) as? [AXUIElement]) ?? [] }
for w in (attr(AXUIElementCreateApplication(pid), kAXWindowsAttribute) as? [AXUIElement]) ?? [] {
    for b in kids(w) where [kAXTitleAttribute, kAXDescriptionAttribute].contains(where: { (attr(b, $0) as? String) == want }) {
        print("press", AXUIElementPerformAction(b, kAXPressAction as CFString).rawValue); exit(0) } }
print("not found")
