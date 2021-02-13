import FoundationKit
import SwiftUI

public struct LoadableImageView<Placeholder: View>: View {
    private let placeholder: Placeholder
    private let state: LoadingState<Data>
    private let size: CGSize

    public init(
        inState state: LoadingState<Data>,
        ofSize size: CGSize,
        @ViewBuilder placeholder: () -> Placeholder
    ) {
        self.state = state
        self.size = size
        self.placeholder = placeholder()
    }

    public var body: some View {
        switch state {
        case .empty:
            return buildClippedView(placeholder, to: size)
        case .loading:
            let stack = ZStack(alignment: .center) {
                placeholder
                ActivityIndicator()
            }
            return buildClippedView(stack, to: size)
        case let .loaded(imageData):
            guard let uiImage = UIImage(data: imageData) else {
                return buildClippedView(placeholder, to: size)
            }
            let image = Image(uiImage: uiImage).resizable()
            return buildClippedView(image, to: size)
        }
    }

    private func buildClippedView<V: View>(_ view: V, to size: CGSize) -> AnyView {
        return AnyView(
            view.scaledToFill()
                .frame(width: size.width, height: size.height)
                .clipped()
        )
    }
}
