public extension Bool {

  func toInt() -> Int {
    self ? 1 : 0
  }
  
  func toString() -> String {
    self ? "true" : "false"
  }
}
