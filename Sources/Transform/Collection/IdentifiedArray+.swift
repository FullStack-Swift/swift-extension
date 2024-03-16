import IdentifiedCollections

public extension IdentifiedArray {
  func toArray() -> [Element] {
    var array: [Element] = []
    for value in self {
      array.append(value)
    }
    return array
  }
}

public extension IdentifiedArray where Element: Hashable {
  func toSet() -> Set<Element> {
    toArray().toSet()
  }
}
