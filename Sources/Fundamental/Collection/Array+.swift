import Foundation

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
