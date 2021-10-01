import Foundation

public extension String {
  func toInt() -> Int? {
    Int(self)
  }
  
  func toDouble() -> Double? {
    Double(self)
  }
  
  func toFloat() -> Float? {
    Float(self)
  }
  
  func toBool() -> Bool {
    self == "true" || self.toInt() == 1
  }
  
  func toURL() -> URL? {
    URL(string: self)
  }
  
  func toUUID() -> UUID? {
    UUID(uuidString: self)
  }
}
