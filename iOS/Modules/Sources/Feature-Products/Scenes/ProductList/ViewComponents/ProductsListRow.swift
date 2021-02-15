import CoreUI
import FoundationKit
import SwiftUI

struct ProductsListRow: View {
    private let data: ProductRowData
    private var imageLoadingState: LoadingState<Data>

    init(
        data: ProductRowData,
        imageLoadingState: LoadingState<Data>
    ) {
        self.data = data
        self.imageLoadingState = imageLoadingState
    }

    var body: some View {
        HStack(alignment: .top, spacing: DS.Spacing.tiny) {
            LoadableImageView(
                inState: imageLoadingState,
                ofSize: .init(width: 80, height: 80),
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
            VStack(alignment: .leading, spacing: DS.Spacing.tiny) {
                Text(data.name)
                    .bold()
                    .foregroundColor(.primary)
                Text(data.description)
                Text(data.price)
            }
//            Spacer()
//            VStack(alignment: .center) {
//                Spacer()
//                Image(systemName: "chevron.right")
//                    .font(.body)
//
//                Spacer()
//            }
        }
    }
}
