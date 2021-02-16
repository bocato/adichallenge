import ComposableArchitecture
import CoreUI
import DependencyManagerInterface
import FoundationKit
import SwiftUI

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
            container: container,
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
            productName _: String,
            productID _: String,
            container _: DependenciesContainerInterface
        ) -> AnyView {
            viewToBeReturned
        }
    }
#endif
