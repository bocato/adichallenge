import ComposableArchitecture
import CoreUI
import FoundationKit
import SwiftUI
import DependencyManagerInterface

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
            Group {
                contentView(viewStore)
                    .overlay(loadingView(viewStore.isLoading))
                    .overlay(errorView(viewStore))
            }
            .onAppear { viewStore.send(.loadData) }
            .navigationBarTitle(viewStore.props.productName)
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
        } else {
            EmptyContentView(
                title: L10n.ProductDetails.EmptyView.title,
                subtitle: L10n.ProductDetails.EmptyView.subtitle,
                onRefresh: { viewStore.send(.loadData) }
            )
            .opacity(viewStore.apiError != nil ? .zero : 1)
            .opacity(viewStore.isLoading ? .zero : 1)
        }
    }
    
    @ViewBuilder
    private func productDetailsView(
        for product: ProductViewData,
        viewStore: ViewStore<ProductDetailsState, ProductDetailsAction>
    ) -> some View {
        Group {
            ProductImageContainer(imageState: viewStore.productImageState)
            ProductInfoView(product: product)
            Divider()
            List {
                ForEach(product.reviews) { review in
                    ProductReviewRow(data: review)
                }
            }
            Button(L10n.ProductDetails.Button.addReview) {
                print("")
            }
            .frame(height: DS.LayoutSize.large.height)
            .buttonStyle(RoundedButtonStyle())
            .padding(.bottom, DS.Spacing.tiny)
        }
        .padding(.bottom, DS.Spacing.tiny)
    }
    
    // MARK: - Stateful Views

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
