import Foundation

public extension Double {
  func toString() -> String {
    String(self)
  }
  
  func toDate() -> Date {
    Date(timeIntervalSince1970: self)
  }
  
  func toTimeInterval() -> TimeInterval {
    self
  }
  
  func toInt() -> Int {
    Int(self)
  }
  
  func toFloat() -> Float {
    toString().toFloat()!
  }
}
