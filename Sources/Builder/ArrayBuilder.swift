import Foundation

@resultBuilder
public enum ArrayBuilder<Element> {
  public typealias Component = [Element]
  
  public static func buildArray(_ component: [Element]) -> [Element] {
    component
  }
  
  public static func buildPartialBlock(first: Element) -> Element {
    first
  }
  
  public static func buildPartialBlock(first: [Element]) -> [Element] {
    first
  }
  
  public static func buildPartialBlock(accumulated: [Element], next: Element) -> [Element] {
    accumulated + [next]
  }
  
  public static func buildPartialBlock(accumulated: [Element], next: [Element]) -> [Element] {
    accumulated + next
  }
  
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
      return [component]
    } else {
      return []
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

public extension Array {
  init(@ArrayBuilder<Element> builder: () -> [Element]) {
    self = builder()
  }
}
