import XCTest
@testable import DependencyManagerInterface
@testable import DependencyManager

extension XCTestCase {
    /// Defines a way to create a `fatalError` expectation.
    /// - Parameter expectedMessage: The message to be shown when the expectation fails.
    /// - Parameter timeout: The expectation timeout.
    /// - Parameter testcase: The block of code that can throw a fatal error.
    func expectFatalError(
        expectedMessage: String,
        timeout: TimeInterval = 2.0,
        testcase: @escaping () -> Void
    ) {
        let expectation = self.expectation(description: "expectingFatalError")
        var assertionMessage: String?
        DependencyManagerInterface.FatalErrorUtil.replaceFatalError { message, _, _ in
            assertionMessage = message
            expectation.fulfill()
            self.unreachable()
        }

        DispatchQueue.global(qos: .userInitiated).async(execute: testcase)

        waitForExpectations(timeout: timeout) { _ in
            XCTAssertEqual(assertionMessage, expectedMessage)
            DependencyManagerInterface.FatalErrorUtil.restoreFatalError()
        }
    }

    private func unreachable() -> Never {
        repeat {
            RunLoop.current.run()
        } while true
    }
}
