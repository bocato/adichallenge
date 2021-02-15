import ComposableArchitecture
import CoreUI
import FoundationKit
import SwiftUI

struct ProductsListView: View {
    // MARK: - Dependencies

    private let store: Store<ProductsListState, ProductsListAction>

    // MARK: - Initialization

    init(store: Store<ProductsListState, ProductsListAction>) {
        self.store = store
    }

    // MARK: - Body

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack {
                    SearchBar(
                        text: viewStore.binding(
                            get: { $0.searchInput },
                            send: { .updateSearchTerm($0) }
                        )
                    )
                    contentView(viewStore)
                        .overlay(loadingView(viewStore.isLoading))
                        .overlay(filteringView(viewStore))
                        .overlay(errorView(viewStore))
                        .overlay(emptyContentView(viewStore))
                }
                .navigationBarTitle(L10n.ProductList.navigationBarTitle)
                .onAppear { viewStore.send(.loadData) }
            }
        }
    }

    // MARK: - Content Views

    @ViewBuilder
    private func contentView(_ viewStore: ViewStore<ProductsListState, ProductsListAction>) -> some View {
        List {
            let productRows = getProductRowsData(for: viewStore)
            ForEach(productRows) { product in
                ProductsListRow(
                    data: product,
                    imageLoadingState: viewStore.productImageStates[product.id] ?? .loading
                )
                .onTapGesture { viewStore.send(.showDetailsForProductWithID(product.id)) }
            }
        }
        .padding(.bottom, DS.Spacing.tiny)
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
    private func filteringView(_ viewStore: ViewStore<ProductsListState, ProductsListAction>) -> some View {
        if viewStore.showFilteringView {
            InformationView(
                data: .init(
                    title: L10n.ProductList.FilteringView.text,
                    image: .init(sfSymbol: "doc.text.magnifyingglass")
                )
            )
        }
        else if viewStore.showEmptyFilterResults {
            InformationView(
                data: .init(
                    title: L10n.ProductList.FilteringView.emptyResults,
                    image: .init(sfSymbol: "hand.thumbsdown")
                )
            )
        }
    }

    @ViewBuilder
    private func emptyContentView(_ viewStore: ViewStore<ProductsListState, ProductsListAction>) -> some View {
        if viewStore.showEmptyContentView {
            EmptyContentView(
                title: L10n.ProductList.EmptyView.title,
                subtitle: L10n.ProductList.EmptyView.subtitle,
                onRefresh: { viewStore.send(.loadData) }
            )
        }
    }

    @ViewBuilder
    private func errorView(_ viewStore: ViewStore<ProductsListState, ProductsListAction>) -> some View {
        if viewStore.apiError != nil {
            ErrorView(onRetry: { viewStore.send(.loadData) })
        }
    }
    
    // MARK: - Helper Methods
    
    private func getProductRowsData(for viewStore: ViewStore<ProductsListState, ProductsListAction>) -> [ProductRowData] {
        var productRows = viewStore.productRows
        if let filteredProductRows = viewStore.filteredProductRows, viewStore.isFiltering {
            productRows = filteredProductRows
        }
        return productRows
    }
}

// MARK: - Specific Components

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
            Spacer()
            VStack(alignment: .center) {
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.body)
                    
                Spacer()
            }
        }
    }
}

