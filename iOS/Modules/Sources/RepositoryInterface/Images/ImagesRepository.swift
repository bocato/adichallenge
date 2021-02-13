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
        _ urlString: String
    ) -> AnyPublisher<Data?, Never> {
        Empty().eraseToAnyPublisher()
    }
}
#endif
