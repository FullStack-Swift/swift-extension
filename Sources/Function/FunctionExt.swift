import Foundation

/// Utilty for applying a transform to a value.
/// - Parameters:
///   - transform: The transform to apply.
///   - input: The value to be transformed.
/// - Returns: The transformed value.
public func apply<T>(_ input: T,_ transform: (inout T) -> Void) -> T {
  var input = input
  transform(&input)
  return input
}


/// Utilty for applying a transform to a value.
/// - Parameters:
///   - transform: The transform to apply.
///   - input: The value to be transformed.
/// - Returns: The transformed value.
public func transform<T>(_ input: T,_ transform: (inout T) -> Void) -> T {
  var input = input
  transform(&input)
  return input
}

/// return description sourceId
/// - Parameters:
///   - id: id description
///   - fileID: fileID description
///   - line: line description
/// - Returns: description
public func sourceId(
  id: String = "",
  fileID: String = #fileID,
  line: UInt = #line
) -> String {
  if id.isEmpty {
    return "fileID: \(fileID) line: \(line)"
  } else {
    return "fileID: \(fileID) line: \(line) id: \(id)"
  }
}

public func mainAsync(
  execute work: @escaping @convention(block) () -> Void
) {
  DispatchQueue.main.async(execute: work)
}

///
/// Submits a work item to a dispatch queue for asynchronous execution after
/// a specified time.
///
/// This method enforces the work item to be sendable.
///
public func delay(
  second: Double,
  execute: @escaping () -> ()
) {
  DispatchQueue.main.asyncAfter(deadline: .now() + second, execute: execute)
}

public let mainQueue = DispatchQueue.main

public let serialQueue = DispatchQueue(
  label: "dq.serial.queue"
)

public let concurrentQueue = DispatchQueue(
  label: "dq.concurrent.queue",
  attributes: .concurrent
)
