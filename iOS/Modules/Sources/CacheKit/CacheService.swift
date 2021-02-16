import Foundation

/// Defines a cache service.
public protocol CacheServiceProtocol {
    func save(data: Data, key: String) throws
    func loadData(for key: String) -> Data?
}
