import SwiftUI
import CoreUI
import FoundationKit
import ComposableArchitecture

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
            VStack {
                SearchBar(
                    text: viewStore.binding(
                        get: { $0.searchTerm } ,
                        send: { .updateSearchTerm($0) }
                    )
                )
                contentView(viewStore)
                    .overlay(loadingView(viewStore.isLoading))
                    .overlay(emptyContentView(viewStore))
                    .overlay(errorView(viewStore))
            }
            .onAppear { viewStore.send(.loadData) }
        }
    }
    
    // MARK: - Cotent Views
    
    @ViewBuilder
    private func contentView(_ viewStore: ViewStore<ProductsListState, ProductsListAction>) ->  some View {
        List {
            ForEach(viewStore.productRows) { product in
                ProductsListRow(
                    data: product,
                    imageLoadingState: viewStore.productImageStates[product.id] ?? .loading
                )
                .onTapGesture { viewStore.send(.shouldDetailsForProductWithID(product.id)) }
            }
        }
        .padding(.bottom, DS.Spacing.xxSmall)
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
    private func emptyContentView(_ viewStore: ViewStore<ProductsListState, ProductsListAction>) -> some View {
        if viewStore.productRows.isEmpty && !viewStore.isLoading {
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
    
}

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
                placeholder: { Rectangle().fill().foregroundColor(.primary) }
            )
            VStack(alignment: .leading, spacing: DS.Spacing.tiny) {
                Text(data.name) // TODO: Product name
                    .bold()
                    .foregroundColor(.primary)
                Text(data.description) // TODO: Product Description
                Text("Price $$$") // TODO: Product price
                Spacer()
            }
        }
//        .frame(height: 120)
    }
}

//#if DEBUG
//struct ProductsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ProductsListView()
//        }
//    }
//}
//#endif
