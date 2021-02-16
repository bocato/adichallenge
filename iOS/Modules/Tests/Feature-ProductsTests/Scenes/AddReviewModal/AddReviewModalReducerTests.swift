import ComposableArchitecture
import RepositoryInterface
import NetworkingInterface
import FoundationKit
import XCTest
@testable import Feature_Products

final class AddReviewModalReducerTests: XCTestCase {
    // MARK: - Properties
    
    private var initialState: AddReviewModalState = .init(props: .fixture())
    private let reviewsRepositoryStub = ReviewsRepositoryStub()
    private let mainQueueFake = DispatchQueue.testScheduler
    private lazy var addReviewModalEnvironment: AddReviewModalEnvironment = .fixture()
    private lazy var testStore: TestStore = {
        return .init(
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
    
    func test_saveReview_whenAPIFails_shouldPresentErrorAlert() {
        // Given
        addReviewModalEnvironment = .fixture(
            reviewsRepository: reviewsRepositoryStub,
            mainQueue: mainQueueFake.eraseToAnyScheduler()
        )
        
        let apiErrorMock: APIError = .fixture()
        reviewsRepositoryStub.postProductReviewResultToBeReturned = .failure(apiErrorMock)
        
        // When / Then
        testStore.assert(
            .send(.saveReview) { nextState in
                nextState.isLoading = true
                nextState.errorAlert = nil
            },
            .do { self.mainQueueFake.advance() },
            .receive(.saveReviewRequest(.failure(apiErrorMock))) { nextState in
                nextState.isLoading = false
                nextState.errorAlert = .init(
                    title: TextState(L10n.AddReviewModal.ErrorAlert.title),
                    message: TextState(L10n.AddReviewModal.ErrorAlert.message)
                )
            }
        )
    }
}
