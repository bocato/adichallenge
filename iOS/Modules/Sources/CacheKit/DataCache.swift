import Foundation

public final class DataCacheService: CacheServiceProtocol {
    // MARK: - Dependencies

    private let fileManager: FileManager
    private let cacheFileName: String

    // MARK: - Properties

    private let cache: Cache<String, Data>

    // MARK: - Initialization

    public init(
        entryLifetime: TimeInterval = 12 * 60 * 60,
        maximumEntryCount: Int = 50,
        fileManager: FileManager = .default,
        cacheFileName: String = "DataCache"
    ) {
        self.fileManager = fileManager
        self.cacheFileName = cacheFileName
        cache = .init(
            entryLifetime: entryLifetime,
            maximumEntryCount: maximumEntryCount
        )
    }

    // MARK: - Public API

    public func save(data: Data, key: String) throws {
        cache.insert(data, forKey: key)
        do {
            try cache.saveToDisk(
                withName: cacheFileName,
                using: fileManager
            )
        } catch {
            throw error
        }
    }

    public func loadData(from key: String) -> Data? {
        return cache.value(forKey: key)
    }
}
