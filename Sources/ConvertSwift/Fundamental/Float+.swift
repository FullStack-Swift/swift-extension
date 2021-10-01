import Foundation

public extension Float {
  func toInt() -> Int {
    Int(self)
  }
  
  func toDouble() -> Double {
    toString().toDouble()!
  }
  
  func toString() -> String {
    String(self)
  }
}
