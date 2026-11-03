import CoreGraphics
import Foundation
// Tiny event poster for QA: ev <cmd> args. Coordinates are global, top-left origin.
let a = CommandLine.arguments.dropFirst().map { $0 }
let src = CGEventSource(stateID: .hidSystemState)
var held: CGEventFlags = []
func post(_ t: CGEventType, _ x: Double, _ y: Double, flags: CGEventFlags? = nil) {
    let e = CGEvent(mouseEventSource: src, mouseType: t, mouseCursorPosition: CGPoint(x: x, y: y), mouseButton: .left)!
    e.flags = flags ?? held; e.post(tap: .cghidEventTap)
}
func key(_ code: CGKeyCode, _ down: Bool, _ flags: CGEventFlags) {
    let e = CGEvent(keyboardEventSource: src, virtualKey: code, keyDown: down)!
    e.type = .flagsChanged; e.flags = flags; e.post(tap: .cghidEventTap)
}
func nap(_ ms: Int) { usleep(useconds_t(ms * 1000)) }
var i = 0
func num() -> Double { defer { i += 1 }; return Double(a[i])! }
while i < a.count {
    let c = a[i]; i += 1
    switch c {
    case "move": post(.mouseMoved, num(), num())
    case "down": post(.leftMouseDown, num(), num())
    case "up": post(.leftMouseUp, num(), num())
    case "drag": // drag x y steps: dragged events from current pos to x,y
        let x = num(), y = num(), n = Int(num())
        let p = CGEvent(source: nil)!.location
        for s in 1...n { let f = Double(s) / Double(n); post(.leftMouseDragged, p.x + (x - p.x) * f, p.y + (y - p.y) * f); nap(15) }
    case "shift": key(56, true, .maskShift); nap(60); key(56, false, [])
    case "ctrl": key(59, true, .maskControl); nap(60); key(59, false, [])
    case "click": let x = num(), y = num(); post(.leftMouseDown, x, y); nap(50); post(.leftMouseUp, x, y)
    case "shiftdown": held = .maskShift; key(56, true, held)
    case "shiftup": held = []; key(56, false, held)
    case "sleep": nap(Int(num()))
    default: fatalError("bad cmd \(c)")
    }
}
