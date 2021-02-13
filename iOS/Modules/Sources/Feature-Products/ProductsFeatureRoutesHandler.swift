import Foundation
import SwiftUIViewProviderInterface

public struct ProductsFeatureRoutesHandler: FeatureRoutesHandler {
    public var routes: [ViewRoute.Type] {
        [
            ProductsListRoute.self,
        ]
    }

    public init() {}

    public func destination<Context, Environment>(
        forRoute route: ViewRoute,
        withContext _: Context,
        environment _: Environment
    ) -> Feature.Type {
        let isValidRoute = routes.contains(where: { $0.self == type(of: route) })
        guard isValidRoute else {
            preconditionFailure()
        }
        return ProductsFeature.self
    }
}
