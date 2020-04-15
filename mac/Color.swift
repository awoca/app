import AppKit

extension NSColor {
    static let indigo = NSColor(named: "indigo")!
}

extension CGColor {
    static let indigo = NSColor.indigo.cgColor
}
