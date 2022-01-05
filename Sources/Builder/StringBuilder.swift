import Foundation

public protocol StringBuilerProtocol {
  var value: String {get}
}

@resultBuilder
public enum StringBuilder {
  public static func buildArray(_ strings: [[String]]) -> [String] {
    strings.flatMap { $0 }
  }
  
  public static func buildBlock(_ strings: [String]...) -> [String] {
    strings.flatMap { $0 }
  }
  
  public static func buildEither(first strings: [String]) -> [String] {
    strings
  }
  
  public static func buildEither(second strings: [String]) -> [String] {
    strings
  }
  
  public static func buildExpression(_ string: String) -> [String] {
    [string]
  }
  
  public static func buildLimitedAvailability(_ string: [String]) -> [String] {
    string
  }
  
  public static func buildOptional(_ strings: [String]?) -> [String] {
    strings ?? []
  }
  
  public static func buildFinalResult(_ strings: [String]) -> [String] {
    strings
  }
}

extension String {
  
  public init(separator: String = "", @StringBuilder builder: () -> [String]) {
    self = builder().joined(separator: separator)
  }
  
}
