import Foundation

@resultBuilder
public enum SetBuilder<Element> {
  
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

public extension Set {
  
  init(@SetBuilder<Element> builder: () -> Set<Element>) {
    self = builder()
  }
  
}

public func setBuilder<Element>(@SetBuilder<Element> builder: () -> Set<Element>) -> Set<Element> {
  builder()
}


