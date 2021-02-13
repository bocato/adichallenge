import CacheKit
import Combine
import Foundation
import NetworkingInterface
import RepositoryInterface

final class InMemoryCache: CacheServiceProtocol {
    private var cache: [String: Data] = [:]

    func save(data: Data, key: String) throws {
        cache[key] = data
    }

    func loadData(from key: String) -> Data? {
        return cache[key]
    }
}

public final class ImagesRepository: ImagesRepositoryProtocol {
    // MARK: - Dependencies

    private let urlSession: URLSessionProtocol
    private let cacheService: CacheServiceProtocol

    // MARK: - Initialization

    public init(
        urlSession: URLSessionProtocol = URLSession.shared,
        cacheService: CacheServiceProtocol? = nil
    ) {
        self.urlSession = urlSession
        self.cacheService = cacheService ?? InMemoryCache() // DataCacheService(cacheFileName: "ImagesCache")
    }

    // MARK: - Public Functions

    public func getImageDataFromURL(
        _ urlString: String
    ) -> AnyPublisher<Data?, Never> {
        if let dataFromCache = cacheService.loadData(from: urlString) {
            return Result<Data?, Never>
                .Publisher(.success(dataFromCache))
                .eraseToAnyPublisher()
        } else {
            return loadImageDataFromNetwork(for: urlString)
                .replaceError(with: nil)
                .flatMap { [cacheService] dataFromNetwork -> AnyPublisher<Data?, Never> in
                    guard let dataFromNetwork = dataFromNetwork else {
                        return Result<Data?, Never>
                            .Publisher(.success(nil))
                            .eraseToAnyPublisher()
                    }
                    try? cacheService.save(
                        data: dataFromNetwork,
                        key: urlString
                    )
                    return Result<Data?, Never>
                        .Publisher(.success(dataFromNetwork))
                        .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        }
    }

    private func loadImageDataFromNetwork(for urlString: String) -> AnyPublisher<Data?, Error> {
        guard let url = URL(string: urlString) else {
            return Result<Data?, Error>
                .Publisher(.success(nil))
                .eraseToAnyPublisher()
        }

        let request = URLRequest(url: url)

        return urlSession
            .dataTaskPublisher(for: request)
            .map { data, response in
                guard
                    let httpStatusCode = (response as? HTTPURLResponse)?.statusCode,
                    200 ... 299 ~= httpStatusCode, data.count > 0
                else { return nil }
                return data
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
