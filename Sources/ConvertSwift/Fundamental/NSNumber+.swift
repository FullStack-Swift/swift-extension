import Foundation

#if os(iOS)
extension NSNumber {
  fileprivate var number: NSNumber {
    return self
  }
}

extension NSNumber {
  //8
  public func toInt8() -> UInt8 {
    number.uint8Value
  }
  
  public func toUInt8() -> UInt8 {
    number.uint8Value
  }
  
  //16
  public func toInt16() -> Int16 {
    number.int16Value
  }
  
  public func toUInt16() -> UInt16 {
    number.uint16Value
  }
  
  //32
  public func toInt32() -> Int32 {
    number.int32Value
  }
  
  public func toUInt32() -> UInt32 {
    number.uint32Value
  }
  
  // 64
  public func toInt64() -> Int64 {
    number.int64Value
  }
  
  public func toUInt64() -> UInt64 {
    number.uint64Value
  }
  
  //float
  public func toFloat() -> Float {
    number.floatValue
  }
  
  //double
  public func toDouble() -> Double {
    number.doubleValue
  }
  
  //bool
  public func toBool() -> Bool {
    number.boolValue
  }
  
  //int
  public func toInt() -> Int {
    number.intValue
  }
  
  //uint
  public func toUInt() -> UInt {
    number.uintValue
  }
  
  //string
  public func toString() -> String {
    number.stringValue
  }
}

#endif
