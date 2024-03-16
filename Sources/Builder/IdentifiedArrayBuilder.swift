import IdentifiedCollections
import Foundation

@available(iOS 13, macOS 12, tvOS 13, watchOS 6, *)
public extension IdentifiedArray where Element: Identifiable {
  init(@ArrayBuilder<Element> builder: () -> [Element]) where ID == Element.ID {
    self = builder().toIdentifiedArray()
  }
}
