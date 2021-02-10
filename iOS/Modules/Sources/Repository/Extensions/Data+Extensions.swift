import Foundation

extension Data {
    func decoded<T: Decodable>(
        using decoder: JSONDecoder = .init()
    ) throws -> T { try decoder.decode(T.self, from: self) as T }
}
