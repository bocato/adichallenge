import SwiftUI

public struct RoundedButtonStyle: ButtonStyle {
    private let foregroundColor: Color
    private let borderColor: Color

    public init(
        foregroundColor: Color = .accentColor,
        borderColor: Color = .accentColor
    ) {
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
    }

    public func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            configuration
                .label
                .frame(minWidth: .zero, maxWidth: .infinity)
                .padding()
                .foregroundColor(foregroundColor)
                .background(
                    RoundedRectangle(
                        cornerRadius: geometry.size.height / 2,
                        style: .continuous
                    ).stroke(borderColor)
                )
                .cornerRadius(geometry.size.height / 2)
                .padding(.horizontal, DS.Spacing.small)
        }
    }
}
