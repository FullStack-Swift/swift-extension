import Foundation

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
