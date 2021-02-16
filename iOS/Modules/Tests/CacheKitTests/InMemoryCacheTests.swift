import XCTest
@testable import CacheKit

final class InMemoryCacheTests: XCTestCase {
    // MARK: - Tests
    
    func test_save_shouldSetDataOnNSCache() {
        // Given
        let memory: NSCache<NSString, NSData> = .init()
        let dataToBeSaved = Data()
        let key = "cached_data"
        let sut: InMemoryCache = .init(memory: memory)
        // When
        XCTAssertNoThrow(
            try sut.save(
                data: dataToBeSaved,
                key: key
            )
        )
        // Then
        let objectFromCache = memory.object(forKey: key as NSString) as Data?
        XCTAssertNotNil(objectFromCache)
        XCTAssertEqual(objectFromCache, dataToBeSaved)
    }
    
    func test_loadData_shouldReturnDataFromNSCache() {
        // Given
        let dataOnCache = Data()
        let key = "cached_data"
        let memory: NSCache<NSString, NSData> = .init()
        memory.setObject(dataOnCache as NSData, forKey: key as NSString)
        let sut: InMemoryCache = .init(memory: memory)
        // When
        let dataFromCache = sut.loadData(for: key)
        // Then
        XCTAssertNotNil(dataFromCache)
        XCTAssertEqual(dataFromCache, dataOnCache)
    }
}
