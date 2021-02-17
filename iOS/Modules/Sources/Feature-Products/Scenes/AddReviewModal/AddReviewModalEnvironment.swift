import Combine
import ComposableArchitecture
import CoreUI
import DependencyManagerInterface
import Foundation
import RepositoryInterface

struct AddReviewModalEnvironment: ResolvableEnvironment {
    @Dependency var reviewsRepository: ReviewsRepositoryProtocol
    var dismissClosure: (Bool) -> Void
    var localeProvider: () -> String?
    var mainQueue: AnySchedulerOf<DispatchQueue>

    init(
        dismissClosure: @escaping (Bool) -> Void,
        localeProvider: @escaping () -> String? = { Locale.autoupdatingCurrent.languageCode },
        mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
    ) {
        self.dismissClosure = dismissClosure
        self.localeProvider = localeProvider
        self.mainQueue = mainQueue
    }
}

#if DEBUG
    extension AddReviewModalEnvironment {
        static func fixture(
            reviewsRepository: ReviewsRepositoryProtocol = ReviewsRepositoryDummy(),
            dismissClosure: @escaping (Bool) -> Void = { _ in false },
            localeProvider: @escaping () -> String? = { nil },
            mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.global().eraseToAnyScheduler()
        ) -> Self {
            var instance: Self = .init(
                dismissClosure: dismissClosure,
                localeProvider: localeProvider,
                mainQueue: mainQueue
            )
            instance._reviewsRepository = .resolvedValue(reviewsRepository)
            return instance
        }
    }
#endif
