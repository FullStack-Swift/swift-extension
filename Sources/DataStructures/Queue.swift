import Foundation

public struct Queue<T> {
  private var array = [T]()
}

public extension Queue {
  var isEmpty: Bool {
    return array.isEmpty
  }
  
  var count: Int {
    return array.count
  }
  
  mutating func enqueue(_ element: T) {
    array.append(element)
  }
  
  mutating func dequeue() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeFirst()
    }
  }
  
  var front: T? {
    return array.first
  }
}
