import Foundation

public extension Optional where Wrapped == Data {
  func toData() -> Data? {
    switch self {
    case .some(let wrapped):
      return wrapped.toData()
    default:
      return .none
    }
  }
  
  func toDictionary() -> [String: Any]? {
    switch self {
    case .some(let wrapped):
      return wrapped.toDictionary()
    default:
      return .none
    }
  }
  
  func toString() -> String? {
    switch self {
    case .some(let wrapped):
      return wrapped.toString()
    default:
      return .none
    }
  }
  
}

public extension Optional where Wrapped == [String: Any] {
  func toData() -> Data? {
    switch self {
    case .some(let wrapped):
      return wrapped.toData()
    default:
      return .none
    }
  }
  
  func toDictionary() -> [String: Any]? {
    switch self {
    case .some(let wrapped):
      return wrapped
    default:
      return .none
    }
  }
  
  func toString() -> String? {
    switch self {
    case .some(let wrapped):
      return wrapped.toString()
    default:
      return .none
    }
  }
  
}

public extension Optional where Wrapped == String {
  func toData() -> Data? {
    switch self {
    case .some(let wrapped):
      return wrapped.toData()
    default:
      return .none
    }
  }
  
  func toDictionary() -> [String: Any]? {
    switch self {
    case .some(let wrapped):
      return wrapped.toDictionary()
    default:
      return .none
    }
  }
  
  func toString() -> String? {
    switch self {
    case .some(let wrapped):
      return wrapped
    default:
      return .none
    }
  }
  
}
