import IdentifiedCollections

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public extension IdentifiedArray where Element: Identifiable {
  
  init(_ builder: () -> IdentifiedArray<ID, Element>) {
    self = builder()
  }
  
  init(_ builder: () -> Array<Element>) where ID == Element.ID {
    self = builder().toIdentifiedArray()
  }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public extension IdentifiedArray where Element: Identifiable {
  
  @discardableResult
  mutating func updateOrAppend(_ items: Self) -> Self {
    for item in items {
      self.updateOrAppend(item)
    }
    return self
  }
  
  @discardableResult
  mutating func updateOrAppend(_ items: [Element]) -> Self {
    for item in items {
      self.updateOrAppend(item)
    }
    return self
  }
  
  @discardableResult
  mutating func updateOrAppend(ifLet item: Element?) -> Self {
    guard let item = item else {
      return self
    }
    self.updateOrAppend(item)
    return self
  }
}
