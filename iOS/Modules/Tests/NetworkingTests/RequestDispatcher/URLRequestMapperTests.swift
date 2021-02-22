import NetworkingInterface
@testable import Networking
import SnapshotTesting
import XCTest

final class URLRequestMapperTests: XCTestCase {
    // MARK: - Tests
    
    func test_mapToURLRequest_whenAllParametersAreProvided_itShouldSetTheValuesCorrectly() throws {
        // Given
        let baseURL = try XCTUnwrap(URL(string: "www.testapi.com"))
        let networkingRequest: AnyURLRequest = .init(
            baseURL: baseURL,
            path: "mypath",
            method: .get,
            bodyParameters: [
                "body": "parameter"
            ],
            headers: [
                "request": "header"
            ]
        )
        // When
        guard let urlRequest = try? networkingRequest.mapToURLRequest() else {
            XCTFail("The mapper is expected to succeed, but it didn't.")
            return
        }
        // Then
        assertSnapshot(matching: urlRequest, as: .dump)
    }
    
    func test_mapToURLRequest_whenMinimumParametersAreProvided_itShouldSetTheValuesCorrectly() throws {
        // Given
        let baseURL = try XCTUnwrap(URL(string: "www.testapi.com"))
        let networkingRequest: AnyURLRequest = .init(
            baseURL: baseURL,
            method: .get
        )
        // When
        guard let urlRequest = try? networkingRequest.mapToURLRequest() else {
            XCTFail("The mapper is expected to succeed, but it didn't.")
            return
        }
        // Then
        assertSnapshot(matching: urlRequest, as: .dump)
    }
    
    func test_mapToURLRequest_whenPathIsNotProvided_itShouldSetTheValuesCorrectly() throws {
        // Given
        let baseURL = try XCTUnwrap(URL(string: "www.testapi.com"))
        let networkingRequest: AnyURLRequest = .init(
            baseURL: baseURL,
            method: .get,
            bodyParameters: [
                "body": "parameter"
            ],
            headers: [
                "request": "header"
            ]
        )
        // When
        guard let urlRequest = try? networkingRequest.mapToURLRequest() else {
            XCTFail("The mapper is expected to succeed, but it didn't.")
            return
        }
        // Then
        assertSnapshot(matching: urlRequest, as: .dump)
    }
    
    func test_mapToURLRequest_whenBodyParametersIsNotProvided_itShouldSetTheValuesCorrectly() throws {
        // Given
        let baseURL = try XCTUnwrap(URL(string: "www.testapi.com"))
        let networkingRequest: AnyURLRequest = .init(
            baseURL: baseURL,
            path: "mypath",
            method: .get,
            headers: [
                "request": "header"
            ]
        )
        // When
        guard let urlRequest = try? networkingRequest.mapToURLRequest() else {
            XCTFail("The mapper is expected to succeed, but it didn't.")
            return
        }
        // Then
        assertSnapshot(matching: urlRequest, as: .dump)
    }
    
    func test_mapToURLRequest_whenHeadersNotProvided_itShouldSetTheValuesCorrectly() throws {
        // Given
        let baseURL = try XCTUnwrap(URL(string: "www.testapi.com"))
        let networkingRequest: AnyURLRequest = .init(
            baseURL: baseURL,
            path: "mypath",
            method: .get,
            bodyParameters: [
                "body": "parameter"
            ]
        )
        // When
        guard let urlRequest = try? networkingRequest.mapToURLRequest() else {
            XCTFail("The mapper is expected to succeed, but it didn't.")
            return
        }
        // Then
        assertSnapshot(matching: urlRequest, as: .dump)
    }
    
//    func test_mapToURLRequest_whenJSONSerializationFails_itShouldThrowAnError() throws {
//        // Given
//        let baseURL = try XCTUnwrap(URL(string: "www.testapi.com"))
//        let networkingRequest: AnyURLRequest = .init(
//            baseURL: baseURL,
//            method: .get
//        )
//        JSONSerializationFake.errorToBeThrown = NSError(domain: "Tests", code: -1, userInfo: nil)
//
//        // When / Then
//        XCTAssertThrowsError(try networkingRequest.mapToURLRequest(using: JSONSerializationFake.self))
//    }
}

// MARK: - Test Doubles
final class JSONSerializationFake: JSONSerialization {
    static var dataToBeReturned: Data = .init()
    static var errorToBeThrown: Error?
    override class func data(withJSONObject obj: Any, options opt: JSONSerialization.WritingOptions = []) throws -> Data {
        if let error = errorToBeThrown {
            throw error
        }
        return dataToBeReturned
    }
}
