import Foundation

extension Result {
  /// Creates a new Result by evaluating a async throwing closure, capturing the
  /// returned value as a success, or any thrown error as a failure.
  ///
  /// - Parameter body: A async throwing closure to evaluate.
  public init(
    catching body: @Sendable () async throws -> Success
  ) async where Failure == Error {
    do {
      let value = try await body()
      self = .success(value)
    }
    catch {
      self = .failure(error)
    }
  }
  
  /// Creates a new Result by evaluating a async closure, capturing the
  /// returned value as a success.
  ///
  /// - Parameter body: A async closure to evaluate.
  public init(
    catching body: @Sendable () async -> Success
  ) async where Failure == Error {
    let value = await body()
    self = .success(value)
  }
}
