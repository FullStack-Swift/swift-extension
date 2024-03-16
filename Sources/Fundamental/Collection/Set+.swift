import Foundation

public extension Set {
  @discardableResult
  mutating func toggle(_ element: Element) -> Element {
    if self.contains(element) {
      self.remove(element)
    } else {
      self.insert(element)
    }
    return element
  }
}
