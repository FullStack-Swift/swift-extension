import Foundation

public extension Array {
  func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> Dictionary<Key, Element> {
    var dict = [Key:Element]()
    for element in self {
      dict[selectKey(element)] = element
    }
    return dict
  }
  
  func toDictionaryWithKeyIndex() -> Dictionary<Int, Element> {
    var dict = [Int: Element]()
    for (index, element) in enumerated() {
      dict[index] = element
    }
    return dict
  }
}

public extension Array where Element: Hashable {
  func toSet() -> Set<Element> {
    Set(self)
  }
}
