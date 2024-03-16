import Foundation
import IdentifiedCollections

public extension Array {
  /// Transform Array to Dictionary with key selected from Element
  func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> Dictionary<Key, Element> {
    var dict = [Key:Element]()
    for element in self {
      dict[selectKey(element)] = element
    }
    return dict
  }
  
  /// Transform Array to Dictionary with key is Index.
  func toDictionaryWithKeyIndex() -> Dictionary<Int, Element> {
    var dict = [Int: Element]()
    for (index, element) in enumerated() {
      dict[index] = element
    }
    return dict
  }
}

/// Transform Array to Set with Element is Hasable
public extension Array where Element: Hashable {
  func toSet() -> Set<Element> {
    Set(self)
  }
}

/// Transform Array to Data with Element is Dictionary
public extension Array where Element == [String: Any] {
  func toData(options opt: JSONSerialization.WritingOptions = []) -> Data? {
    try? JSONSerialization.data(withJSONObject: self, options: opt)
  }
}

/// Transform Array to Data with Element is Codable
public extension Array where Element: Codable {
  func toData(options opt: JSONSerialization.WritingOptions = []) -> Data? {
    compactMap({$0.toDictionary()}).toData(options: opt)
  }
}

/// Transform Array to IdentifiedArrayOf
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public extension Array where Element: Identifiable {
  func toIdentifiedArray() -> IdentifiedArrayOf<Element> {
    var identifiedArray: IdentifiedArrayOf<Element> = []
    for value in self {
      identifiedArray.updateOrAppend(value)
    }
    return identifiedArray
  }
}
