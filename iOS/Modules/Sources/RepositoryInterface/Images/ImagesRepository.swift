import Combine
import Foundation

public protocol ImagesRepositoryProtocol {
    func getImageDataFromURL(
        _ urlString: String
    ) -> AnyPublisher<Data?, Never>
}
