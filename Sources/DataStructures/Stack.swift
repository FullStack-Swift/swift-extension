import Foundation

public struct Stack<T> {
  private var array = [T]()
}

public extension Stack {
  
  var isEmpty: Bool {
    return array.isEmpty
  }
  
  var count: Int {
    return array.count
  }
  
  mutating func push(_ element: T) {
    array.append(element)
  }
  
  mutating func pop() -> T? {
    return array.popLast()
  }
  
  var top: T? {
    return array.last
  }
}
