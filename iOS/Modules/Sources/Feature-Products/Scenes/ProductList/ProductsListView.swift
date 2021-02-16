import ComposableArchitecture
import CoreUI
import DependencyManagerInterface
import FoundationKit
import SwiftUI

public struct ProductsListView: View {
    // MARK: - Dependencies

    private let container: DependenciesContainerInterface
    private let productDetailsViewBuilder: ProductDetailsViewBuilding
    private let store: Store<ProductsListState, ProductsListAction>

    // MARK: - Initialization

    public init() {
        let container = ProductsFeature.container()
        let environment = ProductsListEnvironment()
        environment.initialize(withContainer: container)
        self.init(
            container: container,
            store: .init(
                initialState: .init(),
                reducer: productsListReducer,
                environment: environment
            )
        )
    }

    init(
        container: DependenciesContainerInterface,
        productDetailsViewBuilder: ProductDetailsViewBuilding = ProductDetailsViewBuilder(),
        store: Store<ProductsListState, ProductsListAction>
    ) {
        self.container = container
        self.productDetailsViewBuilder = productDetailsViewBuilder
        self.store = store
    }

    // MARK: - Body

    public var body: some View {
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
                NavigationLink(
                    destination:
                    productDetailsViewBuilder.build(
                        productName: product.name,
                        productID: product.id,
                        container: container
                    ),
                    label: {
                        ProductsListRow(
                            data: product,
                            imageLoadingState: viewStore.productImageStates[product.id] ?? .loading
                        )
                    }
                )
            }
        }
        .padding(.bottom, DS.Spacing.tiny)
        .opacity(viewStore.showProductsList ? 1 : 0)
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
        } else if viewStore.showEmptyFilterResults {
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
