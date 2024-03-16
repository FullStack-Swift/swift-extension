public struct SourceLocation: Codable, Equatable {
  public let fileID: String
  public let line: UInt
  
  public init(fileID: String = #fileID, line: UInt = #line) {
    self.fileID = fileID
    self.line = line
  }
}

// MARK: Generating sourceId
///```swift
///   let sourceLocation: SourceLocation = ...
///   let sourceId = sorceLocation.sourceId
/// ```
extension SourceLocation {
  public var sourceId: String {
    "fileID: \(fileID) line: \(line)"
  }
}

// MARK: SourceLocation: Identifiable
///```swift
/// let sourceIds = IdentifiedArrayOf<SourceLocation>()
///```
extension SourceLocation: Identifiable {
  public var id: String {
    sourceId
  }
}
