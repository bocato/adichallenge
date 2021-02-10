import Foundation
import Combine

public protocol ImagesRepositoryProtocol {
    func getImageDataFromURL(
        _ urlString: String
    ) -> AnyPublisher<Data?, Never>
}
