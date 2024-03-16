import Foundation

public extension Data {
  /// Transform Data to String
  func toString(encoding: String.Encoding = .utf8) -> String? {
    String(data: self, encoding: encoding)
  }
  
  /// Transform Data to Model is Decoable
  func toModel<D>(_ type: D.Type, using decoder: JSONDecoder? = nil) -> D? where D: Decodable {
    let decoder = decoder ?? JSONDecoder()
    return try? decoder.decode(type, from: self)
  }
  
  /// Transform Data to Dictionary
  func toDictionary() -> [String: Any]? {
    do {
      let json = try JSONSerialization.jsonObject(with: self)
      return json as? [String: Any]
    } catch {
      return nil
    }
  }
  
  /// Transform Data to other Data with keyPath
  func toData(keyPath: String? = nil) -> Self {
    guard let keyPath = keyPath else {
      return self
    }
    do {
      let json = try JSONSerialization.jsonObject(with: self, options: [])
      if let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) {
        guard JSONSerialization.isValidJSONObject(nestedJson) else {
          return self
        }
        let data = try JSONSerialization.data(withJSONObject: nestedJson)
        return data
      }
    } catch {
      return self
    }
    return self
  }
  
  /// Check hasData on keyPath
  func hasData(keyPath: String? = nil) -> Bool {
    guard  let keyPath = keyPath else { return true }
    do {
      let json = try JSONSerialization.jsonObject(with: self, options: [])
      if let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) {
        guard JSONSerialization.isValidJSONObject(nestedJson) else {
          return false
        }
        let _ = try JSONSerialization.data(withJSONObject: nestedJson)
        return false
      }
    } catch {
      return false
    }
    return false
  }
  
  subscript(_ keyPath: String? = nil) -> Self? {
    toData(keyPath: keyPath)
  }
  
  /// return new Data with prettyPrinted
  func toDataPrettyPrinted() -> Self {
    do {
      let dataAsJSON = try JSONSerialization.jsonObject(with: self)
      let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
      return prettyData
    } catch {
      return self // fallback to original data if it can't be serialized.
    }
  }
}
