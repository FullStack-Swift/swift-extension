import Foundation

public extension Int {
  func toString() -> String {
    String(self)
  }
  
  func toTimeInterval() -> TimeInterval {
    TimeInterval(self)
  }
  
  func toDouble() -> Double {
    Double(self)
  }
  
  func toDate() -> Date {
    Date(timeIntervalSince1970: self.toDouble())
  }
  
  func toFloat() -> Float {
    Float(self)
  }
  
  func toUInt() -> UInt {
    return UInt(self)
  }
  
}
