import ApplicationServices
import AppKit
// axfind <bundle-id or pid> : prints role, title/desc/value, frame of every element (depth-first).
let arg = CommandLine.arguments[1]
let pid: pid_t = Int32(arg) ?? NSRunningApplication.runningApplications(withBundleIdentifier: arg).first!.processIdentifier
func attr(_ e: AXUIElement, _ k: String) -> AnyObject? { var v: AnyObject?; AXUIElementCopyAttributeValue(e, k as CFString, &v); return v }
func walk(_ e: AXUIElement, _ d: Int) {
    if d > 14 { return }
    let role = attr(e, kAXRoleAttribute) as? String ?? ""
    let t = [kAXTitleAttribute, kAXDescriptionAttribute, kAXValueAttribute, "AXFilename"].compactMap { attr(e, $0) as? String }.filter { !$0.isEmpty }.joined(separator: " | ")
    var p = CGPoint.zero, s = CGSize.zero
    if let pv = attr(e, kAXPositionAttribute) { AXValueGetValue(pv as! AXValue, .cgPoint, &p) }
    if let sv = attr(e, kAXSizeAttribute) { AXValueGetValue(sv as! AXValue, .cgSize, &s) }
    if !t.isEmpty || CommandLine.arguments.count > 2 { print(String(repeating: " ", count: d) + "\(role) [\(t)] @\(Int(p.x)),\(Int(p.y)) \(Int(s.width))x\(Int(s.height))") }
    for c in (attr(e, kAXChildrenAttribute) as? [AXUIElement]) ?? [] { walk(c, d + 1) }
}
let app = AXUIElementCreateApplication(pid)
for w in (attr(app, kAXWindowsAttribute) as? [AXUIElement]) ?? [] { walk(w, 0) }
if CommandLine.arguments.contains("--menubar"), let mb = attr(app, "AXExtrasMenuBar") { walk(mb as! AXUIElement, 0) }
