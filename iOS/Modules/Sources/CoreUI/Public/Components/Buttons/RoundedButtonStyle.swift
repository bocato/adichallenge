import SwiftUI

public struct RoundedButtonStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            configuration
                .label
                .frame(minWidth: .zero, maxWidth: .infinity)
                .padding()
                .foregroundColor(.accentColor)
                .background(
                    RoundedRectangle(
                        cornerRadius: geometry.size.height/2,
                        style: .continuous
                    ).stroke(Color.accentColor)
                )
                .cornerRadius(geometry.size.height/2)
                .padding(.horizontal, DS.Spacing.small)
        }
    }
}
