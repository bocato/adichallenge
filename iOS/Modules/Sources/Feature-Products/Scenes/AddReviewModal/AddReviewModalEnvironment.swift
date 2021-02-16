import Combine
import ComposableArchitecture
import CoreUI
import Foundation
import RepositoryInterface
import DependencyManagerInterface

struct AddReviewModalEnvironment: ResolvableEnvironment {
    @Dependency var reviewsRepository: ReviewsRepositoryProtocol
    var mainQueue: AnySchedulerOf<DispatchQueue>

    init(mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()) {
        self.mainQueue = mainQueue
    }
}

#if DEBUG
extension AddReviewModalEnvironment {
    static func fixture(
        reviewsRepository: ReviewsRepositoryProtocol = ReviewsRepositoryDummy(),
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.global().eraseToAnyScheduler()
    ) -> Self {
        var instance: Self = .init(
            mainQueue: mainQueue
        )
        instance._reviewsRepository = .resolvedValue(reviewsRepository)
        return instance
    }
}
#endif
