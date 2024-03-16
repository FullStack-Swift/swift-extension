import Foundation

public protocol PageProtocol {
  
  associatedtype Success
  
  /// The page's items. Usually models.
  var items: [Success] { get }
  
  /// Metadata containing information about current page, items per page, and total items.
  var metadata: PageMetadata { get }
  
}

/// A single section of a larger, traversable result set.
public struct Page<T>: PageProtocol {
  /// The page's items. Usually models.
  public let items: [T]
  
  /// Metadata containing information about current page, items per page, and total items.
  public let metadata: PageMetadata
  
  /// Creates a new `Page`.
  public init(items: [T], metadata: PageMetadata) {
    self.items = items
    self.metadata = metadata
  }
  
  /// Maps a page's items to a different type using the supplied closure.
  public func map<U>(_ transform: (T) throws -> (U)) rethrows -> Page<U> {
    try .init(
      items: self.items.map(transform),
      metadata: self.metadata
    )
  }
}

extension Page: Encodable where T: Encodable {}

extension Page: Decodable where T: Decodable {}

extension Page: Equatable where T: Equatable {}

extension Page: Hashable where T: Hashable {}

extension Page: Sendable where T: Sendable {}

public protocol PageMetadataProtocol {
  
  /// Current page number. Starts at `1`.
  var page: Int { get }
  
  /// Max items per page.
  var per: Int { get }
  
  /// Total number of items available.
  var total: Int { get }
}

extension PageMetadataProtocol {
  
  /// Computed total number of pages with `1` being the minimum.
  public var pageCount: Int {
    let count = Int((Double(self.total)/Double(self.per)).rounded(.up))
    return count < 1 ? 1 : count
  }
  
  public var hasNextPage: Bool {
    self.page * self.per < total
  }
  
  public var totalPages: Int {
    pageCount
  }
  
}

/// Metadata for a given `Page`.
public struct PageMetadata: Codable, PageMetadataProtocol {
  /// Current page number. Starts at `1`.
  public let page: Int
  
  /// Max items per page.
  public let per: Int
  
  /// Total number of items available.
  public let total: Int
  
  /// Creates a new `PageMetadata` instance.
  ///
  /// - Parameters:
  ///.  - page: Current page number.
  ///.  - per: Max items per page.
  ///.  - total: Total number of items available.
  public init(page: Int, per: Int, total: Int) {
    self.page = page
    self.per = per
    self.total = total
  }
}

extension PageMetadata: Equatable {}

extension PageMetadata: Hashable {}

extension PageMetadata: Sendable {}

/// Represents information needed to generate a `Page` from the full result set.
public struct PageRequest: Codable {
  /// Page number to request. Starts at `1`.
  public let page: Int
  
  /// Max items per page.
  public let per: Int
  
  enum CodingKeys: String, CodingKey {
    case page = "page"
    case per = "per"
  }
  
  /// `Decodable` conformance.
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 1
    self.per = try container.decodeIfPresent(Int.self, forKey: .per) ?? 10
  }
  
  /// Crates a new `PageRequest`
  /// - Parameters:
  ///   - page: Page number to request. Starts at `1`.
  ///   - per: Max items per page.
  public init(page: Int, per: Int) {
    self.page = page
    self.per = per
  }
  
  var start: Int {
    (self.page - 1) * self.per
  }
  
  var end: Int {
    self.page * self.per
  }
}

extension PageRequest: Equatable {}

extension PageRequest: Hashable {}

extension PageRequest: Sendable {}

public struct PagedResponse<T> {
  public let page: Int
  public let totalPages: Int
  public let results: [T]
  
  public init(page: Int, totalPages: Int, results: [T]) {
    self.page = page
    self.totalPages = totalPages
    self.results = results
  }
  
  public var hasNextPage: Bool {
    page < totalPages
  }
}

extension PagedResponse: Encodable where T: Encodable {}

extension PagedResponse: Decodable where T: Decodable {}

extension PagedResponse: Equatable where T: Equatable {}

extension PagedResponse: Hashable where T: Hashable {}

extension PagedResponse: Sendable where T: Sendable {}

import IdentifiedCollections

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public struct PagedIdentifiedArray<T: Identifiable> {
  public let page: Int
  public let totalPages: Int
  public let results: IdentifiedArrayOf<T>
  
  public init(page: Int, totalPages: Int, results: IdentifiedArrayOf<T>) {
    self.page = page
    self.totalPages = totalPages
    self.results = results
  }
  
  public var hasNextPage: Bool {
    page < totalPages
  }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension PagedIdentifiedArray: Encodable where T: Encodable {}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension PagedIdentifiedArray: Decodable where T: Decodable {}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension PagedIdentifiedArray: Equatable where T: Equatable {}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension PagedIdentifiedArray: Hashable where T: Hashable {}

public protocol AnyPageProtocol {
  /// The type of items that this items returns.
  associatedtype Success
  
  /// current page number. Starts at `1`.
  var page: Int { get }
  
  /// Total number of page avaliable.
  var totalPages: Int { get }
  /// The pages's items. Usualy models
  var results: [Success] { get }
}

public extension AnyPageProtocol {
  
  /// return ``Page`` frome SwiftExt
  func toPage() -> Page<Success> {
    Page(
      items: results,
      metadata: PageMetadata(page: page, per: 20, total: totalPages)
    )
  }
  
  var hasNextPage: Bool {
    page < totalPages
  }
}

public struct AnyPage<T>: AnyPageProtocol {
  public let page: Int
  public let totalPages: Int
  public let results: [T]
  
  public init(page: Int, totalPages: Int, results: [T]) {
    self.page = page
    self.totalPages = totalPages
    self.results = results
  }
}

extension AnyPage: Equatable where T: Equatable {}

extension AnyPage: Sendable where T: Sendable {}

extension AnyPage: Encodable where T: Encodable {}

extension AnyPage: Decodable where T: Decodable {}

extension AnyPage: Hashable where T: Hashable {}
