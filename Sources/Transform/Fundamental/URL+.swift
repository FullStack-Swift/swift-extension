import Foundation

public extension URL {
  func toString() -> String {
    absoluteString
  }
  
  func toQueryParameters() -> [String: String]? {
    guard let queryItems = URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems else {
      return nil
    }
    return Dictionary(queryItems.lazy.compactMap {
      guard let value = $0.value else { return nil }
      return ($0.name, value)
    }) { first, _ in first }
  }
  
}
