import SwiftUI
import CoreUI
import ComposableArchitecture

struct ProductsListView: View {
    // MARK: - Dependencies
    
    private let store: Store<ProductsListState, ProductsListAction>
    
    // MARK: - Initialization
    
    init(store: Store<ProductsListState, ProductsListAction>) {
        self.store = store
    }
    
    // MARK: - UI
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                SearchBar(
                    layout: .init(
                        placeholder: "Search",
                        cancelText: "Cancel"
                    ),
                    text: viewStore.binding(
                        get: { $0.searchTerm } ,
                        send: { .updateSearchTerm($0) }
                    )
                )
                if viewStore.isLoading {
                    ActivityIndicator()
                } else {
                    List {
                        ForEach(viewStore.state.productRows) { product in
                            ProductsListRow(data: product)
    //                            .onTapGesture { viewStore.send(.shouldDetailsForItemWithID(item.id)) }
                        }
                    }
                }
            }.onAppear { viewStore.send(.loadData) }
        }
    }
}

struct ProductsListRow: View {
    private let data: ProductRowData
//    private var imageLoadingState: LoadingState<Data>
    
    init(
        data: ProductRowData//,
//        imageLoadingState: LoadingState<Data>
    ) {
        self.data = data
//        self.imageLoadingState = imageLoadingState
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 5) {
//            LoadableImageView(
//                inState: imageLoadingState,
//                ofSize: .init(width: 80, height: 80),
//                placeholder: { Rectangle().fill().foregroundColor(.primary) }
//            )
            Text("IMAGE HERE") // TODO: Load Image!
                .frame(width: 80, height: 80)
            VStack(alignment: .leading, spacing: 5) {
                Text(data.name) // TODO: Product name
                    .bold()
                    .foregroundColor(.primary)
                Text(data.description) // TODO: Product Description
                Text("Price $$$") // TODO: Product price
                Spacer()
            }
        }
        .frame(height: 120)
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
