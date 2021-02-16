import CoreUI
import SwiftUI

struct ProductReviewRow: View {
    typealias Data = ProductViewData.Review
    private let data: Data

    init(data: Data) {
        self.data = data
    }

    var body: some View {
        VStack {
            HStack {
                Text("\(L10n.ProductDetails.ProductReviewRow.locale) \(data.flagEmoji)")
                    .bold()
                    .font(.body)
                Spacer()
                Text("\(L10n.ProductDetails.ProductReviewRow.rating) \(data.rating)")
                    .bold()
                    .font(.body)
            }
            .padding(.bottom, DS.Spacing.xxSmall)

            Text(data.text)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}
