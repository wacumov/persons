import SwiftUI

public struct DefaultButtonStyle: ButtonStyle {
    let light: Colors
    let dark: Colors
    let fontStyle: FontStyle
    let maxWidth: CGFloat?

    @Environment(\.colorScheme) var colorScheme: ColorScheme

    public typealias FontStyle = (font: Font, weight: Font.Weight)
    public static let defaultFontStyle: FontStyle = (.body, .semibold)

    public init(_ colors: Colors, fontStyle: FontStyle = Self.defaultFontStyle, maxWidth: CGFloat? = .infinity) {
        self.init(light: colors, dark: colors, fontStyle: fontStyle, maxWidth: maxWidth)
    }

    public init(light: Colors, dark: Colors, fontStyle: FontStyle = Self.defaultFontStyle, maxWidth: CGFloat? = .infinity) {
        self.light = light
        self.dark = dark
        self.fontStyle = fontStyle
        self.maxWidth = maxWidth
    }

    public func makeBody(configuration: Configuration) -> some View {
        let colors: Colors = colorScheme == .light ? light : dark
        let (foreground, background) = (colors.foreground, colors.background)
        return configuration.label
            .padding(16)
            .font(fontStyle.font)
            .fontWeight(fontStyle.weight)
            .frame(maxWidth: maxWidth)
            .foregroundColor(configuration.isPressed ? foreground.opacity(0.7) : foreground)
            .background(configuration.isPressed ? background.opacity(0.2) : background)
            .cornerRadius(16)
    }
}

public extension ButtonStyle where Self == DefaultButtonStyle {
    typealias Style = DefaultButtonStyle

    static var primary: Style {
        Style((.blue, .white))
    }

    static var secondary: Style {
        Style(light: (.systemGray5, .primary), dark: (.systemGray5, .white))
    }
}

#if DEBUG
#Preview {
    VStack {
        Button("Primary") {}.buttonStyle(.primary)
        Button("Secondary") {}.buttonStyle(.secondary)
    }
    .padding()
}
#endif
