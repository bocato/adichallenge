import ComposableArchitecture
import CoreUI
import FoundationKit
import SwiftUI

struct ProductDetailsView: View {
    // MARK: - Dependencies

    private let store: Store<ProductDetailsState, ProductDetailsAction>

    // MARK: - Initialization

    init(store: Store<ProductDetailsState,  ProductDetailsAction>) {
        self.store = store
    }

    // MARK: - Body

    var body: some View {
        WithViewStore(store) { viewStore in
            contentView(viewStore)
                .overlay(loadingView(viewStore.isLoading))
                .overlay(errorView(viewStore))
                
        }
    }

    // MARK: - Content Views

    @ViewBuilder
    private func contentView(_ viewStore: ViewStore<ProductDetailsState, ProductDetailsAction>) -> some View {
        if let product = viewStore.product {
            productDetailsView(
                for: product,
                viewStore: viewStore
            )
        } else if !viewStore.isLoading {
            EmptyContentView(
                title: "Empty Title",
                subtitle: "Empty Subtitle",
                onRefresh: { viewStore.send(.loadData) }
            )
        }
    }
    
    @ViewBuilder
    private func productDetailsView(
        for product: ProductViewData,
        viewStore: ViewStore<ProductDetailsState, ProductDetailsAction>
    ) -> some View {
        HStack(alignment: .top, spacing: DS.Spacing.tiny) {
            GeometryReader { geometry in
                LoadableImageView(
                    inState: viewStore.productImageState,
                    ofSize: .init(
                        width: 400,
                        height: 400
                    ),
                    placeholder: { Rectangle().fill().foregroundColor(.primary) }
                )
            }
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: DS.Spacing.tiny) {
                    Text(product.name)
                        .bold()
                        .foregroundColor(.primary)
                    Text(product.price)
                        .bold()
                }
                Text(product.description)
            }
//            List {
//                ForEach(productRows) { product in
//                    ProductsListRow(
//                        data: product,
//                        imageLoadingState: viewStore.productImageStates[product.id] ?? .loading
//                    )
//                    .onTapGesture { viewStore.send(.showDetailsForProductWithID(product.id)) }
//                }
//            }
//            .padding(.bottom, DS.Spacing.tiny)
        }
    }

    @ViewBuilder
    private func loadingView(_ isVisible: Bool) -> some View {
        if isVisible {
            Spacer()
            ActivityIndicator()
            Spacer()
        }
    }

    @ViewBuilder
    private func errorView(_ viewStore: ViewStore<ProductDetailsState, ProductDetailsAction>) -> some View {
        if viewStore.apiError != nil {
            ErrorView(onRetry: { viewStore.send(.loadData) })
        }
    }
}
