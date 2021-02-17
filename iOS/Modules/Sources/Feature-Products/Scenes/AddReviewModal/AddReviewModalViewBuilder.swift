import ComposableArchitecture
import CoreUI
import DependencyManagerInterface
import FoundationKit
import SwiftUI

protocol AddReviewModalBuilding {
    func build(
        onDismiss: @escaping (Bool) -> Void,
        productID: String,
        container: DependenciesContainerInterface
    ) -> AnyView
}

final class AddReviewModalBuilder: AddReviewModalBuilding {
    func build(
        onDismiss: @escaping (Bool) -> Void,
        productID: String,
        container: DependenciesContainerInterface
    ) -> AnyView {
        let environment = AddReviewModalEnvironment(
            dismissClosure: onDismiss
        )
        environment.initialize(withContainer: container)
        return AddReviewModalView(
            store: .init(
                initialState: .init(
                    props: .init(
                        productID: productID
                    )
                ),
                reducer: addReviewModalReducer,
                environment: environment
            )
        )
        .eraseToAnyView()
    }
}

#if DEBUG
    final class AddReviewModalViewBuilderStub: AddReviewModalBuilding {
        var viewToBeReturned: AnyView = .init(EmptyView())
        func build(
            onDismiss _: @escaping (Bool) -> Void,
            productID _: String,
            container _: DependenciesContainerInterface
        ) -> AnyView {
            viewToBeReturned
        }
    }
#endif
