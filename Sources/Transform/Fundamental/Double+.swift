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
  
  func toNano() -> Double {
    self * 1_000_000_000
  }
  
  func toGiga() -> Double {
    self / 1_000_000_000
  }
  
  var nano: Double {
    self * 1_000_000_000
  }
  
  var giga: Double {
    self / 1_000_000_000
  }
}
