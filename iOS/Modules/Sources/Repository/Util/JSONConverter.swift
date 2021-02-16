import Foundation

protocol JSONConverterProtocol {
    func convertToJSON<T: Encodable>(
        _ value: T
    ) -> [String: Any]?
}
final class DefaultJSONConverter: JSONConverterProtocol {
    
    // MARK: - Dependencies
    
    private let encoder: JSONEncoder
    private let serializer: JSONSerialization.Type
    
    // MARK: - Initialization
    
    init(
        encoder: JSONEncoder = .init(),
        serializer: JSONSerialization.Type = JSONSerialization.self
    ) {
        self.encoder = encoder
        self.serializer = serializer
    }
    
    // MARK: - Public API
    
    func convertToJSON<T: Encodable>(
        _ value: T
    ) -> [String: Any]? {
        guard let data = try? encoder.encode(value) else { return nil }
        guard let jsonValue = try? serializer.jsonObject(with: data, options: .allowFragments) else { return  nil }
        let json = jsonValue as? [String: Any]
        return json
    }
}
