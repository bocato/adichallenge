import Combine
import Foundation

public protocol ImagesRepositoryProtocol {
    func getImageDataFromURL(
        _ urlString: String
    ) -> AnyPublisher<Data?, Never>
}

#if DEBUG
    public final class ImagesRepositoryDummy: ImagesRepositoryProtocol {
        public init() {}

        public func getImageDataFromURL(
            _: String
        ) -> AnyPublisher<Data?, Never> {
            Empty().eraseToAnyPublisher()
        }
    }

    public final class ImagesRepositoryStub: ImagesRepositoryProtocol {
        public init() {}

        public var imageDataToBeReturned: Data?
        public func getImageDataFromURL(
            _: String
        ) -> AnyPublisher<Data?, Never> {
            Result<Data?, Never>
                .success(imageDataToBeReturned)
                .publisher
                .eraseToAnyPublisher()
        }
    }
#endif
