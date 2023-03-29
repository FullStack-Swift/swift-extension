import Foundation

public extension Dictionary {
  func toArrayKeys() -> Array<Key> {
    keys.map {$0}
  }
  
  func toArrayValues() -> Array<Value> {
    values.map {$0}
  }
  
  func toArray() -> Array<Self> {
    Array(arrayLiteral: self)
  }
}

public extension Dictionary where Value: Hashable {
  func toSet() -> Set<Self> {
    toArray().toSet()
  }
  
  func has(key: Self.Key) -> Bool {
    self[key] != nil
  }
}
