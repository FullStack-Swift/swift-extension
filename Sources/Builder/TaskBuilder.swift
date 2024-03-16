import Foundation

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
@resultBuilder
public enum TaskBuilder<Success: Sendable> {
  
  public typealias Element = Task<Success, Never>
  
  public typealias Component = [Element]
  
  public static func buildBlock() -> Component {
    []
  }
  
  public static func buildBlock(_ component: Element) -> Component {
    [component]
  }
  
  public static func buildBlock(_ components: Element...) -> Component {
    components
  }
  
  public static func buildOptional(_ component: Element?) -> Component {
    if let component {
      [component]
    } else {
      []
    }
  }
  
  public static func buildEither(first component: Element) -> Component {
    [component]
  }
  
  public static func buildEither(second component: Element) -> Component {
    [component]
  }
  
  public static func buildLimitedAvailability(_ component: Element) -> Component {
    [component]
  }
}

@resultBuilder
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public enum ThrowingTaskBuilder<Success: Sendable> {
  
  public typealias Element = Task<Success, Error>
  
  public typealias Component = [Element]
  
  public static func buildBlock() -> Component {
    []
  }
  
  public static func buildBlock(_ component: Element) -> Component {
    [component]
  }
  
  public static func buildBlock(_ components: Element...) -> Component {
    components
  }
  
  public static func buildOptional(_ component: Element?) -> Component {
    if let component {
      [component]
    } else {
      []
    }
  }
  
  public static func buildEither(first component: Element) -> Component {
    [component]
  }
  
  public static func buildEither(second component: Element) -> Component {
    [component]
  }
  
  public static func buildLimitedAvailability(_ component: Element) -> Component {
    [component]
  }
}
