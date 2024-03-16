import Foundation
import IdentifiedCollections

public extension Set {
  func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> Dictionary<Key, Element> {
    toArray().toDictionary(with: selectKey)
  }
  
  func toDictionaryWithKeyIndex() -> Dictionary<Int, Element> {
    toArray().toDictionaryWithKeyIndex()
  }
  
  func toArray() -> Array<Element> {
    Array(self)
  }
}
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public extension Set {
  func toIdentifiedArray() -> IdentifiedArrayOf<Element> where Element: Identifiable {
    toArray().toIdentifiedArray()
  }
}
