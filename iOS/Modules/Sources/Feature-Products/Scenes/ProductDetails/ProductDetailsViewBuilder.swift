
import ComposableArchitecture
import CoreUI
import FoundationKit
import SwiftUI
import DependencyManagerInterface

protocol ProductDetailsViewBuilding {
    func build(
        productName: String,
        productID: String,
        container: DependenciesContainerInterface
    ) -> AnyView
}

final class ProductDetailsViewBuilder: ProductDetailsViewBuilding {
    func build(
        productName: String,
        productID: String,
        container: DependenciesContainerInterface
    ) -> AnyView {
        let environment = ProductDetailsEnvironment()
        environment.initialize(withContainer: container)
        return ProductDetailsView(
            store: .init(
                initialState: .init(
                    props: .init(
                        productName: productName,
                        productID: productID
                    )
                ),
                reducer: productDetailsReducer,
                environment: environment
            )
        )
        .eraseToAnyView()
    }
}

#if DEBUG
final class ProductDetailsViewBuilderStub: ProductDetailsViewBuilding {
    var viewToBeReturned: AnyView = .init(EmptyView())
    func build(
        productName: String,
        productID: String,
        container: DependenciesContainerInterface
    ) -> AnyView {
        viewToBeReturned
    }
}
#endif
