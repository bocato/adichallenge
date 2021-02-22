import ComposableArchitecture
@testable import Feature_Products
import FoundationKit
import NetworkingInterface
import RepositoryInterface
import XCTest

final class AddReviewModalReducerTests: XCTestCase {
    // MARK: - Properties

    private var initialState: AddReviewModalState = .init(props: .fixture())
    private let reviewsRepositoryMock = ReviewsRepositoryMock()
    private let mainQueueFake = DispatchQueue.testScheduler
    private lazy var addReviewModalEnvironment: AddReviewModalEnvironment = .fixture()
    private lazy var testStore: TestStore = {
        .init(
            initialState: initialState,
            reducer: addReviewModalReducer,
            environment: addReviewModalEnvironment
        )
    }()

    // MARK: - Tests

    func test_updateReviewRating_shouldUpdateState() {
        // Given
        initialState.rating = nil
        // When / Then
        testStore.assert(
            .send(.updateReviewRating(2)) { nextState in
                nextState.rating = 2
            }
        )
    }

    func test_updateReviewText_shouldUpdateState() {
        // Given
        initialState.reviewText = ""
        // When / Then
        testStore.assert(
            .send(.updateReviewText("New Text")) { nextState in
                nextState.reviewText = "New Text"
            }
        )
    }

    func test_saveReview_whenLocaleIsNilAndRatingIsGreaterThanZero_andRequestSucceeds_itShouldSendTheCorrectRequest_then() {
        // Given
        initialState.rating = 1
        var dismissClosureValuePassed: Bool?
        var dismissClosureCalled = false
        addReviewModalEnvironment = .fixture(
            reviewsRepository: reviewsRepositoryMock,
            dismissClosure: { valuePassed in
                dismissClosureValuePassed = valuePassed
                dismissClosureCalled = true
            },
            localeProvider: { nil },
            mainQueue: mainQueueFake.eraseToAnyScheduler()
        )

        reviewsRepositoryMock.postProductReviewResultToBeReturned = .success(())

        // When / Then
        testStore.assert(
            .send(.saveReview) { nextState in
                nextState.isLoading = true
            },
            .do { [mainQueueFake] in mainQueueFake.advance() },
            .receive(.saveReviewRequest(.success(()))) { [reviewsRepositoryMock] nextState in
                nextState.isLoading = false
                XCTAssertEqual(reviewsRepositoryMock.postProductReviewRequestPassed?.locale, "en_nl")
                XCTAssertEqual(reviewsRepositoryMock.postProductReviewRequestPassed?.rating, 2)
            },
            .receive(.dismissItSelf(true)) { _ in
                XCTAssertEqual(dismissClosureValuePassed, true)
                XCTAssertTrue(dismissClosureCalled)
            }
        )
    }

    func test_saveReview_whenRatingNil_andRequestSucceeds_itShouldSendTheCorrectRequest_thenDismissItself() {
        // Given
        initialState.rating = nil
        var dismissClosureValuePassed: Bool?
        var dismissClosureCalled = false
        addReviewModalEnvironment = .fixture(
            reviewsRepository: reviewsRepositoryMock,
            dismissClosure: { valuePassed in
                dismissClosureValuePassed = valuePassed
                dismissClosureCalled = true
            },
            mainQueue: mainQueueFake.eraseToAnyScheduler()
        )

        reviewsRepositoryMock.postProductReviewResultToBeReturned = .success(())

        // When / Then
        testStore.assert(
            .send(.saveReview) { nextState in
                nextState.isLoading = true
            },
            .do { [mainQueueFake] in mainQueueFake.advance() },
            .receive(.saveReviewRequest(.success(()))) { [reviewsRepositoryMock] nextState in
                nextState.isLoading = false
                XCTAssertEqual(reviewsRepositoryMock.postProductReviewRequestPassed?.rating, 0)
            },
            .receive(.dismissItSelf(true)) { _ in
                XCTAssertTrue(dismissClosureCalled)
                XCTAssertEqual(dismissClosureValuePassed, true)
            }
        )
    }

    func test_saveReview_whenAPIFails_shouldPresentErrorAlert() {
        // Given
        addReviewModalEnvironment = .fixture(
            reviewsRepository: reviewsRepositoryMock,
            mainQueue: mainQueueFake.eraseToAnyScheduler()
        )

        let apiErrorMock: APIError = .fixture()
        reviewsRepositoryMock.postProductReviewResultToBeReturned = .failure(apiErrorMock)

        // When / Then
        testStore.assert(
            .send(.saveReview) { nextState in
                nextState.isLoading = true
                nextState.errorAlert = nil
            },
            .do { [mainQueueFake] in mainQueueFake.advance() },
            .receive(.saveReviewRequest(.failure(apiErrorMock))) { nextState in
                nextState.isLoading = false
                nextState.errorAlert = .init(
                    title: TextState(L10n.AddReviewModal.ErrorAlert.title),
                    message: TextState(L10n.AddReviewModal.ErrorAlert.message)
                )
            }
        )
    }

    func test_errorAlertDismissed_shouldSetErrorAlertAsNil() {
        // Given
        initialState.errorAlert = .init(title: TextState("Tests!"))
        // When / Then
        testStore.assert(
            .send(.errorAlertDismissed) { nextState in
                nextState.errorAlert = nil
            }
        )
    }
}
