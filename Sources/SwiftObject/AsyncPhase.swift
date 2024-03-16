/// An immutable representation of the most recent asynchronous operation phase. This type differs form  ``TaskAsyncPhase``
///  type in that it uses  two generic for the success case,  and Failure for failure case.
public enum AsyncPhase<Success, Failure: Error> {
  /// Represents a pending phase meaning that the operation has not been started.
  case pending
  
  /// Represents a running phase meaning that the operation has been started, but has not yet provided a result.
  case running
  
  /// Represents a success phase meaning that the operation provided a value with success.
  case success(Success)
  
  /// Represents a failure phase meaning that the operation provided an error with failure.
  case failure(Failure)
  
  /// Creates a new phase with the given result by mapping either of a `success` or
  /// a `failure`.
  ///
  /// - Parameter result: A result value to be mapped.
  public init(_ result: Result<Success, Failure>) {
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
  ) where Failure == Error {
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
    catching body: () async throws -> Success
  ) async where Failure == Error {
    self = .running
    do {
      let value = try await body()
      self = .success(value)
    }
    catch {
      self = .failure(error)
    }
  }
  
  /// Returns a Boolean value indicating whether this instance represents a `pending`.
  public var isPending: Bool {
    guard case .pending = self else {
      return false
    }
    return true
  }
  
  /// Returns a Boolean value indicating whether this instance represents a `running`.
  public var isRunning: Bool {
    guard case .running = self else {
      return false
    }
    return true
  }
  
  /// Returns a Boolean value indicating whether this instance represents a `success`.
  public var isSuccess: Bool {
    guard case .success = self else {
      return false
    }
    return true
  }
  
  /// Returns a Boolean value indicating whether this instance represents a `failure`.
  public var isFailure: Bool {
    guard case .failure = self else {
      return false
    }
    return true
  }
  
  /// Returns a success value if this instance is `success`, otherwise returns `nil`.
  public var value: Success? {
    guard case .success(let value) = self else {
      return nil
    }
    return value
  }
  
  /// Returns an error if this instance is `failure`, otherwise returns `nil`.
  public var error: Failure? {
    guard case .failure(let error) = self else {
      return nil
    }
    return error
  }
  
  /// Returns a result converted from the phase.
  /// If this instance represents a `pending` or a `running`, this returns nil.
  public var result: Result<Success, Failure>? {
    switch self {
      case .pending, .running:
        nil
      case .success(let success):
          .success(success)
      case .failure(let error):
          .failure(error)
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
  /// - Parameter transform: A closure that takes the success value of this instance.
  /// - Returns: An `AsyncPhase` instance with the result of evaluating `transform` as the new success value if this instance represents a success.
  public func map<NewSuccess>(
    _ transform: (Success) -> NewSuccess
  ) -> AsyncPhase<NewSuccess, Failure> {
    flatMap { .success(transform($0)) }
  }
  
  /// Returns a new result, mapping any failure value using the given transformation.
  /// - Parameter transform: A closure that takes the failure value of the instance.
  /// - Returns: An `AsyncPhase` instance with the result of evaluating `transform` as the new failure value if this instance represents a failure.
  public func mapError<NewFailure: Error>(
    _ transform: (Failure) -> NewFailure
  ) -> AsyncPhase<Success, NewFailure> {
    flatMapError { .failure(transform($0)) }
  }
  
  /// Returns a new result, mapping any success value using the given transformation and unwrapping the produced phase.
  /// - Parameter transform: A closure that takes the success value of the instance.
  /// - Returns: An `AsyncPhase` instance, either from the closure or the previous `.success`.
  public func flatMap<NewSuccess>(
    _ transform: (Success) -> AsyncPhase<NewSuccess, Failure>
  ) -> AsyncPhase<NewSuccess, Failure> {
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
  
  /// Returns a new result, mapping any failure value using the given transformation and unwrapping the produced phase.
  /// - Parameter transform: A closure that takes the failure value of the instance.
  /// - Returns: An `AsyncPhase` instance, either from the closure or the previous `.failure`.
  public func flatMapError<NewFailure: Error>(
    _ transform: (Failure) -> AsyncPhase<Success, NewFailure>)
  -> AsyncPhase<Success, NewFailure> {
    switch self {
      case .pending:
        return .pending
      case .running:
        return .running
      case .success(let value):
        return .success(value)
      case .failure(let error):
        return transform(error)
    }
  }
}

extension AsyncPhase {
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
        return .pending
      case .running:
        return .running
      case .success(_):
        return .success
      case .failure(_):
        return .failure
    }
  }
  
  /// A boolean value indicating whether `self` is ``AsyncPhase/pending`` or ``AsyncPhase/running``.
  public var isLoading: Bool {
    switch self.status {
      case .pending, .running:
        return true
      case .success, .failure:
        return false
    }
  }
  
  /// A boolean value indicating whether `self` is ``AsyncPhase/success(_:)`` or ``AsyncPhase/failure(_:)``.
  public var hasResponded: Bool {
    switch self.status {
      case .pending, .running:
        return false
      case .success, .failure:
        return true
    }
  }
}

extension AsyncPhase {
  /// Merge AysncPhase
  /// We receive Success and show to the view only If 2 phase is Success.
  /// - Parameter other: other AsyncPhase
  /// - Returns: AsyncPhase
  public func merge(_ other: Self) -> AsyncPhase<(Success, Success), Failure> {
    switch (self, other) {
      case (.failure(let error), _):
        return .failure(error)
      case (_, .failure(let error)):
        return .failure(error)
      case (.pending, _):
        return .pending
      case (_, .pending):
        return .pending
      case (.running, _), (_, .running):
        return .running
      case (.success(let lhs), .success(let rhs)):
        return .success((lhs, rhs))
    }
  }
}

// MARK: Transform to AsyncPhase

extension TaskResult {
  
  /// Transform A TaskResult to AsyncPhase
  ///
  ///     let taskResult: TaskResult<Success> = ...
  ///     let asyncPhase = taskResult.toAsyncPhase()
  ///
  /// - Returns: AsyncPhase
  
  public func toAsyncPhase() -> AsyncPhase<Success, Error> {
    AsyncPhase(self)
  }
}

extension Result {
  
  /// Transform A Result to AsyncPhase
  ///
  ///     let result: Result<Success, any Error> = ...
  ///     let asyncPhase = result.toAsyncPhase()
  ///
  /// - Returns: AsyncPhase
  
  public func toAsyncPhase() -> AsyncPhase<Success, Failure> {
    AsyncPhase(self)
  }
}

extension TaskAsyncPhase {
  
  /// Transform A TaskAsyncPhase to AsyncPhase
  ///
  ///     let taskAsyncPhase: TaskAsyncPhase<Success> = ...
  ///     let asyncPhase = taskAsyncPhase.toAsyncPhase()
  ///
  /// - Returns: AsyncPhase
  public func toAsyncPhase() -> AsyncPhase<Success, Error> {
    switch self {
      case .pending:
          .pending
      case .running:
          .running
      case .success(let success):
          .success(success)
      case .failure(let error):
          .failure(error)
    }
  }
}

extension AsyncPhase: Decodable where Success: Decodable, Failure: Decodable {}

extension AsyncPhase: Encodable where Success: Encodable, Failure: Encodable {}

extension AsyncPhase: Equatable where Success: Equatable, Failure: Equatable {}

extension AsyncPhase: Hashable where Success: Hashable, Failure: Hashable {}

extension AsyncPhase: Sendable where Success: Sendable {}

import Foundation.NSData

public typealias AsyncData = AsyncPhase<Data, any Error>
