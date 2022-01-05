import Foundation
import SwiftUI

#if canImport(SwiftUI)
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension String {
  func toText() -> Text {
    Text(self)
  }
}
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension Sequence where Element == Text {
  func joined(separator: Text = Text("")) -> Text {
    return reduce(Text("")) { (result, text) in
      return result + separator + text
    }
  }
}
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
@resultBuilder
public struct TextBuilder {
  public static func buildArray(_ texts: [[Text]]) -> [Text] {
    texts.flatMap { $0 }
  }
  
  public static func buildBlock(_ texts: [Text]...) -> [Text] {
    texts.flatMap { $0 }
  }
  
  public static func buildEither(first texts: [Text]) -> [Text] {
    texts
  }
  
  public static func buildEither(second texts: [Text]) -> [Text] {
    texts
  }
  
  public static func buildExpression(_ string: String) -> [Text] {
    [string.toText()]
  }
  
  public static func buildExpression(_ text: Text) -> [Text] {
    [text]
  }
  
  public static func buildLimitedAvailability(_ texts: [Text]) -> [Text] {
    texts
  }
  
  public static func buildOptional(_ texts: [Text]?) -> [Text] {
    texts ?? []
  }
  
  public static func buildFinalResult(_ texts: [Text]) -> [Text] {
    texts
  }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension Text {
  init(separator: Text = Text(""), @TextBuilder builder: () -> [Text]) {
    self = builder().joined(separator: separator)
  }
  
  init(separator: String = "", @TextBuilder builder: () -> [Text]) {
    self.init(separator: Text(separator), builder: builder)
  }
}
#endif
