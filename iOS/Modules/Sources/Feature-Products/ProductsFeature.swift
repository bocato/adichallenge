import SwiftUIViewProviderInterface
import Foundation

public struct ProductsFeature: Feature {
    public static func buildView<Context, Environment>(
        fromRoute route: ViewRoute?,
        withContext context: Context,
        environment: Environment
    ) -> AnyCustomView {
        switch (route, context, environment) {
        case let (route, _, _) where route is ProductsListRoute:
            return ProductsListView(
                store: .init(
                    initialState: .init(viewState: .loading),
                    reducer: productsListReducer,
                    environment: (environment as? ProductsListEnvironment) ?? ProductsListEnvironment()
                )
            )
            .eraseToAnyCustomView()
        default: // Default app view
            return ProductsListView(
                store: .init(
                    initialState: .init(viewState: .loading),
                    reducer: productsListReducer,
                    environment: ProductsListEnvironment()
                )
            ).eraseToAnyCustomView()
        }
    }
}
