/// An immutable representation of the most recent asynchronous operation phase. This type differs form  ``AsyncPhase``
///  type in that it uses only one generic for the success case, leaving the failure case as an untyped `Error`.
public enum TaskAsyncPhase<Success> {
  /// Represents a pending phase meaning that the operation has not been started.
  case pending
  
  /// Represents a running phase meaning that the operation has been started, but has not yet provided a result.
  case running
  
  /// Represents a success phase meaning that the operation provided a value with success.
  case success(Success)
  
  /// Represents a failure phase meaning that the operation provided an error with failure.
  case failure(Error)
  
  /// Creates a new phase with the given result by mapping either of a `success` or
  /// a `failure`.
  ///
  /// - Parameter result: A result value to be mapped.
  public init<Failure>(_ result: Result<Success, Failure>) {
    switch result {
      case .success(let value):
        self = .success(value)
      case .failure(let error):
        self = .failure(error)
    }
  }
  
  /// Creates a new phase with the given result by mapping either of a `success` or
  /// a `failure`.
  ///
  /// - Parameter result: A result value to be mapped.
  public init(
    _ result: TaskResult<Success>
  ) {
    switch result {
      case .success(let value):
        self = .success(value)
      case .failure(let error):
        self = .failure(error)
    }
  }
  
  /// Creates a new phase by evaluating a async throwing closure, capturing the
  /// returned value as a success, or any thrown error as a failure.
  ///
  /// - Parameter body: A async throwing closure to evaluate.
  public init(
    catching body: @Sendable () async throws -> Success
  ) async {
    self = .running
    do {
      let value = try await body()
      self = .success(value)
    }
    catch {
      self = .failure(error)
    }
  }
  
  /// A boolean value indicating whether `self` is ``TaskAsyncPhase/isPending``.
  public var isPending: Bool {
    guard case .pending = self else {
      return false
    }
    
    return true
  }
  
  /// A boolean value indicating whether `self` is ``TaskAsyncPhase/success(_:)``.
  public var isSuccess: Bool {
    guard case .success = self else {
      return false
    }
    
    return true
  }
  
  /// A boolean value indicating whether `self` is ``TaskAsyncPhase/failure(_:)``.
  public var isFailure: Bool {
    guard case .failure = self else {
      return false
    }
    
    return true
  }
  
  /// Returns the success value if `self` is ``TaskAsyncPhase/success(_:)``, otherwise returns `nil`.
  public var value: Success? {
    guard case .success(let value) = self else {
      return nil
    }
    return value
  }
  
  /// Returns the error value if `self` is ``TaskAsyncPhase/failure(_:)``, otherwise returns `nil`.
  public var error: (any Error)? {
    guard case .failure(let error) = self else {
      return nil
    }
    
    return error
  }
  
  /// Returns a result converted from the phase.
  /// If this instance represents a `pending` or a `running`, this returns nil.
  public var result: Result<Success, Error>? {
    switch self {
      case .pending, .running:
        return nil
      case .success(let success):
        return .success(success)
      case .failure(let error):
        return .failure(error)
    }
  }
  
  /// Returns a taskResult converted from the phase.
  /// if this instance represents a `pending` or a `runiing`, this returns nil.
  public var taskResult: TaskResult<Success>? {
    if let result {
      TaskResult(result)
    } else {
      nil
    }
  }
  
  /// Returns a new phase, mapping any success value using the given transformation.
  ///
  /// - Parameter transform: A closure that takes the success value of this instance.
  ///
  /// - Returns: An ``TaskAsyncPhase`` instance with the result of evaluating `transform`
  ///   as the new success value if this instance represents a success.
  public func map<NewSuccess>(
    _ transform: (Success) -> NewSuccess
  ) -> TaskAsyncPhase<NewSuccess> {
    flatMap { .success(transform($0)) }
  }
  
  /// Returns a new phase, mapping any failure value using the given transformation.
  ///
  /// - Parameter transform: A closure that takes the failure value of the instance.
  ///
  /// - Returns: An ``TaskAsyncPhase`` instance with the result of evaluating `transform` as
  ///            the new failure value if this instance represents a failure.
  public func mapError<Failure: Error>(
    _ transform: (any Error) -> Failure
  ) -> TaskAsyncPhase<Success> {
    flatMapError { .failure(transform($0)) }
  }
  
  /// Returns a new phase, mapping any success value using the given transformation
  /// and unwrapping the produced result.
  ///
  /// - Parameter transform: A closure that takes the success value of the instance.
  ///
  /// - Returns: An ``TaskAsyncPhase`` instance, either from the closure or the previous
  ///            ``TaskAsyncPhase/success(_:)``.
  public func flatMap<NewSuccess>(
    _ transform: (Success) -> TaskAsyncPhase<NewSuccess>
  ) -> TaskAsyncPhase<NewSuccess> {
    switch self {
      case .pending:
          .pending
      case .running:
          .running
      case .success(let value):
        transform(value)
      case .failure(let error):
          .failure(error)
    }
  }
  
  /// Returns a new phase, mapping any failure value using the given transformation
  /// and unwrapping the produced result.
  ///
  /// - Parameter transform: A closure that takes the failure value of the instance.
  ///
  /// - Returns: An ``TaskAsyncPhase`` instance, either from the closure or the previous
  ///            ``TaskAsyncPhase/failure(_:)``.
  public func flatMapError(
    _ transform: (any Error) -> TaskAsyncPhase<Success>
  ) -> TaskAsyncPhase<Success> {
    switch self {
      case .pending:
          .pending
      case .running:
          .running
      case .success(let value):
          .success(value)
      case .failure(let error):
        transform(error)
    }
  }
}

extension TaskAsyncPhase {
  /// The status using in HookUpdateStrategy to order handle response phase.
  public enum StatusPhase: Hashable, Equatable {
    /// Represents a pending phase meaning that the operation has not been started.
    case pending
    
    /// Represents a running phase meaning that the operation has been started, but has not yet provided a result.
    case running
    
    /// Represents a success phase meaning that the operation provided a value with success.
    case success
    
    /// Represents a failure phase meaning that the operation provided an error with failure.
    case failure
  }
  
  /// the status of phase which we can compare to update HookUpdateStrategy.
  public var status: StatusPhase {
    switch self {
      case .pending:
          .pending
      case .running:
          .running
      case .success(_):
          .success
      case .failure(_):
          .failure
    }
  }
  
  /// A boolean value indicating whether `self` is ``TaskAsyncPhase/pending`` or ``TaskAsyncPhase/running``.
  public var isLoading: Bool {
    switch self.status {
      case .pending, .running:
        return true
      case .success, .failure:
        return false
    }
  }
  
  /// A boolean value indicating whether `self` is ``TaskAsyncPhase/success(_:)`` or ``TaskAsyncPhase/failure(_:)``.
  public var hasResponded: Bool {
    switch self.status {
      case .pending, .running:
        return false
      case .success, .failure:
        return true
    }
  }
}

extension TaskAsyncPhase {
  /// Merge TaskAsyncPhase
  /// We receive Success and show to the view only If 2 phase is Success.
  /// - Parameter other: other TaskAsyncPhase
  /// - Returns: TaskAsyncPhase
  public func merge(_ other: Self) -> TaskAsyncPhase<(Success, Success)> {
    switch (self, other) {
      case (.pending, _):
        return .pending
      case (_, .pending):
        return .pending
      case (.running, _):
        return .running
      case (_, .running):
        return .running
      case (.failure(let error), _):
        return .failure(error)
      case (_, .failure(let error)):
        return .failure(error)
      case (.success(let lhs), .success(let rhs)):
        return .success((lhs, rhs))
    }
  }
}

// MARK: Transform to TaskAsyncPhase

extension TaskResult {
  
  /// Transform A TaskResult to TaskAsyncPhase
  ///
  ///       let taskResult: TaskResult<Success> = ...
  ///       let taskAsyncPhase = taskResult.toTaskAsyncPhase()
  ///
  /// - Returns: TaskAsyncPhase
  public func toTaskAsyncPhase() -> TaskAsyncPhase<Success> {
    TaskAsyncPhase(self)
  }
}

extension Result {
  
  /// Transform A Result to TaskAsyncPhase
  ///
  ///     let result: Result<Success, any Error> = ...
  ///     let taskAsyncPhase = result.toTaskAsyncPhase()
  ///
  /// - Returns: TaskAsyncPhase
  public func toTaskAsyncPhase() -> TaskAsyncPhase<Success> {
    TaskAsyncPhase(self)
  }
}

extension AsyncPhase {
  
  /// Transform A AsyncPhase to TaskAsyncPhase
  ///
  ///     let asyncPhase: AsyncPhase<Success, any Error> = ...
  ///     let taskAsyncPhase = asyncPhase.toTaskAsyncPhase()
  ///
  /// - Returns: TaskAsyncPhase
  public func toTaskAsyncPhase() -> TaskAsyncPhase<Success> {
    switch self {
      case .pending:
        return .pending
      case .running:
        return .running
      case .success(let success):
        return .success(success)
      case .failure(let failure):
        return .failure(failure)
    }
  }
}

import Foundation.NSData

public typealias TaskAsyncData = TaskAsyncPhase<Data>
