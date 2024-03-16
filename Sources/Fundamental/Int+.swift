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
    UInt(self)
  }
  
  func toBool() -> Bool {
    self == 1 ? true : false
  }
  
  func toNano() -> Int {
    self * 1_000_000_000
  }
  
  func toGiga() -> Double {
    Double(self / 1_000_000_000)
  }
  
  var nano: Double {
    Double(self / 1_000_000_000)
  }
  
  var giga: Int {
    self * 1_000_000_000
  }
}

extension UInt64 {
  public init(seconds: Double) {
    self.init(seconds.nano)
  }
}
