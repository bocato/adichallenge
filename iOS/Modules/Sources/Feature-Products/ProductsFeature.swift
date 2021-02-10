import SwiftUIViewProviderInterface
import Foundation

public struct ProductsFeature: Feature {
    public static func buildView<Context, Environment>(
        fromRoute route: ViewRoute?,
        withContext context: Context,
        environment: Environment
    ) -> AnyCustomView {
        switch (route, context, environment) {
        case let (route, _, productsListEvironment as ProductsListEnvironment) where route is ProductsListRoute:
            return ProductsListView(
                store: .init(
                    initialState: .init(),
                    reducer: productsListReducer,
                    environment: productsListEvironment
                )
            )
            .eraseToAnyCustomView()
        default: // Default app view
            return ProductsListView(
                store: .init(
                    initialState: .init(),
                    reducer: productsListReducer,
                    environment: ProductsListEnvironment()
                )
            )
            .eraseToAnyCustomView()
        }
    }
}
