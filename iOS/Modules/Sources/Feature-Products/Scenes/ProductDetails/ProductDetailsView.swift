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

// MARK: - Specific Components
// TODO: Move this to files...

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
