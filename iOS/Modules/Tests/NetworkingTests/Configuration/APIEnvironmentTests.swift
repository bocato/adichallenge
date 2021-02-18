import NetworkingInterface
@testable import Networking
import TestingToolkit
import XCTest

final class APIEnvironmentTests: XCTestCase {
    // MARK: - Tests
    func test_whenTheBaseURLProviderReturnsNil_itShouldThrowFatalError() {
        // Given
        let baseURLProviderStub: BaseURLProviderStub = .init()
        baseURLProviderStub.urlToBeReturned = nil
        let sut: APIEnvironment = .init(
            currentEnvironment: .development,
            baseURLProvider: baseURLProviderStub
        )
        // When / Then
        expectFatalError(
            expectedMessage: "There are no requests without a baseURL, it must be set!",
            testcase: { _ = sut.baseURL(forEndpoint: "dummy")  }
        )
    }
}
