import IdentifiedCollections
import Foundation

public extension IdentifiedArray where Element: Codable {
  func toData(options opt: JSONSerialization.WritingOptions = []) -> Data? {
    toArray().toData(options: opt)
  }
}

public extension IdentifiedArray {
  func toArray() -> [Element] {
    var array: [Element] = []
    for value in self {
      array.append(value)
    }
    return array
  }
  
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

public extension IdentifiedArray where Element: Hashable {
  func toSet() -> Set<Element> {
    toArray().toSet()
  }
}
