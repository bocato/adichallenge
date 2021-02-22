import Foundation

/// Save and load data to memory and disk cache.
public final class InMemoryCache: CacheServiceProtocol { // TODO: Implement a DiskCache, in the future...
    /// For getting or loading data in memory.
    private let memory: NSCache<NSString, NSData>

    // MARK: - Initialization

    public convenience init() {
        self.init(memory: .init())
    }

    init(memory: NSCache<NSString, NSData>) {
        self.memory = memory
    }

    // MARK: - Public API

    public func save(data: Data, key: String) throws {
        memory.setObject(data as NSData, forKey: key as NSString)
    }

    public func loadData(for key: String) -> Data? {
        let dataFromMemory = memory.object(forKey: key as NSString)
        return dataFromMemory as Data?
    }
}
