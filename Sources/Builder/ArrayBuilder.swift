import Foundation

@resultBuilder
public enum ArrayBuilder<Element> {
  public static func buildBlock(_ components: Element...) -> [Element] {
    components
  }
}

public extension Array {
  init(@ArrayBuilder<Element> builder: () -> [Element]) {
    self = builder()
  }
}
