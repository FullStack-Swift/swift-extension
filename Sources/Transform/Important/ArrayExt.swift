import Foundation
import IdentifiedCollections

public extension Array {
  @discardableResult
  func appending(value element: Element) -> Self {
    var copy = self
    copy.append(element)
    return copy
  }
}

public extension Array where Element: Equatable {
  var removedDuplicates: [Element] {
    var uniqueValues: [Element] = []
    forEach { item in
      guard !uniqueValues.contains(item) else { return }
      uniqueValues.append(item)
    }
    return uniqueValues
  }
}

public extension Array where Element == [String: Any] {
  
  func toData(options opt: JSONSerialization.WritingOptions = []) -> Data? {
    try? JSONSerialization.data(withJSONObject: self, options: opt)
  }
}


public extension Array where Element: Codable {
  
  func toData(options opt: JSONSerialization.WritingOptions = []) -> Data? {
    compactMap({$0.toDictionary()}).toData(options: opt)
  }
}

public extension IdentifiedArray where Element: Codable {
  
  func toData(options opt: JSONSerialization.WritingOptions = []) -> Data? {
    toArray().toData(options: opt)
  }
}
