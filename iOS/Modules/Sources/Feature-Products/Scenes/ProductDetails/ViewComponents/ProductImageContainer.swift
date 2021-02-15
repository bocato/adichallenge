import SwiftUI
import CoreUI
import FoundationKit

struct ProductImageContainer: View  {
    // MARK: - Properties
    
    private let imageState: LoadingState<Data>
    
    // MARK: - Initialization
    
    init(imageState: LoadingState<Data>) {
        self.imageState = imageState
    }
    
    // MARK: - Body
    var body: some View {
        LoadableImageView(
            inState: imageState,
            ofSize: .init(
                width: 250,
                height: 250
            ),
            placeholder: {
                Image(systemName: "photo.on.rectangle.angled")
                    .resizable()
                    .frame(
                        width: DS.LayoutSize.large.width,
                        height: DS.LayoutSize.large.height
                    )
                    .foregroundColor(.secondary)
            }
        )
    }
}
