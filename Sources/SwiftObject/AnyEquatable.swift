import Foundation

struct AnyEquatable: Equatable {
  private let value: any Equatable
  private let equals: (Self) -> Bool
  
  public init(_ value: any Equatable) {
    if let key = value as? Self {
      self = key
      return
    }
    self.value = value
    self.equals = { other in
      areEqual(value, other.value)
    }
  }
  
  /// Returns a Boolean value indicating whether two values are equal.
  /// - Parameters:
  ///   - lhs: A value to compare.
  ///   - rhs: Another value to compare.
  /// - Returns: A Boolean value indicating whether two values are equal.
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.equals(rhs)
  }
}

extension Equatable {
  public func isEqual(_ other: any Equatable) -> Bool {
    guard let other = other as? Self else {
      return other.isExactlyEqual(self)
    }
    return self == other
  }
  
  public func isEqual(_ other: any Any) -> Bool {
    guard let other = other as? any Equatable else {
      return false
    }
    return isEqual(other)
  }
  
  public func isEqual(_ other: some Any) -> Bool {
    //    self == any as? Self
    guard let other = other as? any Equatable else {
      return false
    }
    return isEqual(other)
  }
  
  private func isExactlyEqual(_ other: any Equatable) -> Bool {
    guard let other = other as? Self else {
      return false
    }
    return self == other
  }
}

public func areEqual(_ lhs: Any,_ rhs: Any) -> Bool {
  guard
    let lhs = lhs as? any Equatable,
    let rhs = rhs as? any Equatable
  else { return false }
  
  return lhs.isEqual(rhs)
}

public func areEqual(_ lhs: any Equatable, _ rhs: any Equatable) -> Bool {
  lhs.isEqual(rhs)
}

public func areEqual(_ lhs: any Hashable, _ rhs: any Hashable) -> Bool {
  lhs.isEqual(rhs)
}
