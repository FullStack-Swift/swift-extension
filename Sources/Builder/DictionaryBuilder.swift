import Foundation

@resultBuilder
public enum DictionaryBuilder<Key: Hashable, Value> {
  static func buildBlock(_ components: Dictionary<Key, Value>...) -> Dictionary<Key, Value> {
    components.reduce(into: [:]) {
      $0.merge($1) { _, new in new }
    }
  }
}

public extension Dictionary {
  init(@DictionaryBuilder<Key, Value> builder: () -> Dictionary) {
    self = builder()
  }
}
