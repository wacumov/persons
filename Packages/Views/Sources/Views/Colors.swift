import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public typealias Colors = (background: Color, foreground: Color)

#if canImport(UIKit)
public extension Color {
    static let systemBackground = Color(UIColor.systemBackground)
    static let systemGray6 = Color(UIColor.systemGray6)
    static let systemGray5 = Color(UIColor.systemGray5)
    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
}

#elseif canImport(AppKit)
public extension Color {
    static let systemBackground = Color(NSColor.windowBackgroundColor)
    static let systemGray6 = Color(NSColor.quaternaryLabelColor.withAlphaComponent(0.5))
    static let systemGray5 = Color(NSColor.quaternaryLabelColor.withAlphaComponent(0.3))
    static let systemGroupedBackground = Color(NSColor.windowBackgroundColor)
}
#endif
