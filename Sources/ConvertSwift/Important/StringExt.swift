import Foundation

public extension String {
  func toData(using:String.Encoding = .utf8) -> Data? {
    return self.data(using: using)
  }
  
  func toModel<D>(_ type: D.Type, using decoder: JSONDecoder? = nil) -> D? where D : Decodable {
    return self.toData()?.toModel(type,using: decoder)
  }
  
  func toDictionary() -> [String: Any]? {
    guard let data = self.toData() else {return nil}
    do {
      return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    } catch {
      return nil
    }
  }
}
