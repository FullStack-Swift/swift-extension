import Foundation

public extension Encodable {
  func toData(using encoder: JSONEncoder? = nil) -> Data? {
    let encoder = encoder ?? JSONEncoder()
    return try? encoder.encode(self)
  }
  
  func toDictionary(using encoder: JSONEncoder? = nil) -> [String: Any]? {
    toData(using: encoder)?.toDictionary()
  }
  
  func toModel<D>(_ type: D.Type, using encoder: JSONEncoder? = nil) -> D? where D: Decodable {
    toData(using: encoder)?.toModel(type)
  }
}
