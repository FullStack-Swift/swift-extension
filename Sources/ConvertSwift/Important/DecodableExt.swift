import Foundation

extension Decodable {
  static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) -> Self? {
    try? decoder.decode(Self.self, from: data)
  }
}
