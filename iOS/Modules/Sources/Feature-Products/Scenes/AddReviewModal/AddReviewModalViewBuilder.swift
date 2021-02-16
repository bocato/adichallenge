
import ComposableArchitecture
import CoreUI
import FoundationKit
import SwiftUI
import DependencyManagerInterface

protocol AddReviewModalBuilding {
    func build(
        dismiss: @escaping () -> Void,
        productID: String,
        container: DependenciesContainerInterface
    ) -> AnyView
}

final class AddReviewModalBuilder: AddReviewModalBuilding {
    func build(
        dismiss: @escaping () -> Void,
        productID: String,
        container: DependenciesContainerInterface
    ) -> AnyView {
        let environment = AddReviewModalEnvironment(
            dismissClosure: dismiss
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
        dismiss: @escaping () -> Void,
        productID: String,
        container: DependenciesContainerInterface
    ) -> AnyView {
        viewToBeReturned
    }
}
#endif
