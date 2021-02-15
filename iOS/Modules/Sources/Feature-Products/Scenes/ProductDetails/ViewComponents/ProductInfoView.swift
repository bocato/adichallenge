import Foundation
import SwiftUI
import CoreUI

struct ProductInfoView: View {
    // MARK: - Properties
    
    private let product: ProductViewData
    
    // MARK: - Initialization
    
    init(product: ProductViewData) {
        self.product = product
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text(product.name)
                    .font(.title)
                    .foregroundColor(.primary)
                Spacer()
                Text(product.price)
                    .font(.title)
                    .foregroundColor(.accentColor)
            }
            .padding(.horizontal, DS.Spacing.small)
            .padding(.bottom, DS.Spacing.xxSmall)
            
            Text(product.description)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}
