import Foundation

public extension Dictionary {
  func toData() -> Data? {
    do {
      return try JSONSerialization.data(withJSONObject: self, options: [])
    } catch {
      return nil
    }
  }
  
  func toModel<D>(_ type: D.Type, using decoder: JSONDecoder? = nil) -> D? where D : Decodable {
    toData()?.toModel(type, using: decoder)
  }
  
  func toString(using: String.Encoding = .utf8) -> String? {
    guard let data = self.toData() else {return nil}
    return String(data: data, encoding: using)
  }
}
