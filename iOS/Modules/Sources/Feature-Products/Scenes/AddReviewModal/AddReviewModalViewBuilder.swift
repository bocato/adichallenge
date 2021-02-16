
import ComposableArchitecture
import CoreUI
import FoundationKit
import SwiftUI
import DependencyManagerInterface

protocol AddReviewModalBuilding {
    func build(
        productID: String,
        container: DependenciesContainerInterface
    ) -> AnyView
}

final class AddReviewModalBuilder: AddReviewModalBuilding {
    func build(
        productID: String,
        container: DependenciesContainerInterface
    ) -> AnyView {
        let environment = AddReviewModalEnvironment()
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
        productID: String,
        container: DependenciesContainerInterface
    ) -> AnyView {
        viewToBeReturned
    }
}
#endif
