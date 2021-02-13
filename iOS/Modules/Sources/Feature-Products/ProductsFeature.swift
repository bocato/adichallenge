import Foundation
import SwiftUIViewProviderInterface

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
                    initialState: .init(),
                    reducer: productsListReducer,
                    environment: (environment as? ProductsListEnvironment) ?? ProductsListEnvironment()
                )
            )
            .eraseToAnyCustomView()
        default: // Default app view
            guard let container = (environment as? ContainerAwareEnvironment)?.container else {
                preconditionFailure("This should never happen!") // @TODO: Review and improve everything below this...
            }
            let environment = ProductsListEnvironment()
            environment.initialize(withContainer: container)
            return ProductsListView(
                store: .init(
                    initialState: .init(),
                    reducer: productsListReducer,
                    environment: environment
                )
            ).eraseToAnyCustomView()
        }
    }
}
