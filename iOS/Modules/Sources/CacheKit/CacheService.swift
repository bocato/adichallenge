import Foundation

/// Defines the CacheService errors.
///
/// - encryptionFailed: The key encription has failed.
/// - couldNotSaveData: The data could not be saved.
/// - couldNotLoadData: The data could not be loaded.
/// - raw: Some system error not previously defined.
public enum CacheServiceError: Error {
    case encryptionFailed
    case couldNotSaveData
    case raw(Error)
}

/// Defines a cache service.
public protocol CacheServiceProtocol {
    func save(data: Data, key: String) throws
    func loadData(from key: String) -> Data?
}
