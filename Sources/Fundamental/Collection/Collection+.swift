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
  
  subscript(safe index: Index?) -> Element? {
    get {
      guard let index = index else { return nil }
      return self[safe: index]
    }
    set {
      guard let index = index else { return }
      self[safe: index] = newValue
    }
  }
}

public extension Collection {
  subscript(safe index: Index?) -> Element? {
    get {
      guard let index = index else { return nil }
      return self[safe: index]
    }
  }
  
  subscript(safe index: Index) -> Element? {
    get {
      guard indices.contains(index) else { return nil }
      return self[index]
    }
  }
}

public extension MutableCollection {
  
  var isNotEmpty: Bool {
    !self.isEmpty
  }
}

public extension Collection {
  
  var isNotEmpty: Bool {
    !self.isEmpty
  }
}
