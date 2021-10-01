import Foundation

public extension MutableCollection {
  subscript(safe index: Index) -> Element? {
    get {
      indices.contains(index) ? self[index] : nil
    }
    mutating set {
      if indices.contains(index), let value = newValue {
        self[index] = value
      }
    }
  }
}
