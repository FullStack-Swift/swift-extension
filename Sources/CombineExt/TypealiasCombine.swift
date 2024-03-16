#if canImport(Combine)
import Combine

// MARK: typealias Combine
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public typealias SetCancellables = Set<AnyCancellable>

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public typealias ActionSubject<Action> = PassthroughSubject<Action, Never>

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public typealias StateSubject<State> = CurrentValueSubject<State, Never>

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public typealias ObservableEvent = ActionSubject<()>

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Set where Element: AnyCancellable {
  public func dispose() {
    for item in self {
      item.cancel()
    }
  }
}

// MARK: Combine Extension
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher where Output == Never, Failure == Never {
  public func start() -> Cancellable {
    return sink(receiveValue: { _ in })
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher where Self.Failure == Never {
  public func assign<Root: AnyObject>(
    to keyPath: WritableKeyPath<Root, Self.Output>,
    weakly object: Root
  ) -> AnyCancellable {
    return self.sink { [weak object] output in
      object?[keyPath: keyPath] = output
    }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
  public func onReceiveValue(
    _ receiveValue: @escaping () -> ()
  ) -> AnyCancellable {
    sink { _ in
    } receiveValue: { _ in
      receiveValue()
    }
  }
  
  public func onCompletion(
    _ receiveCompletion: @escaping () -> ()
  ) -> AnyCancellable {
    sink { _ in
      receiveCompletion()
    } receiveValue: { _ in }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
  public func replaceError(
    replace: @escaping (Failure) -> Self.Output
  ) -> AnyPublisher<Self.Output, Never> {
    return `catch` { error in
      Result.Publisher(replace(error))
    }.eraseToAnyPublisher()
  }
  
  public func ignoreError() -> AnyPublisher<Output, Never> {
    return `catch` { _ in
      Empty()
    }.eraseToAnyPublisher()
  }
  
  public func void() -> AnyPublisher<(), Failure> {
    map { _ in
      return
    }
    .eraseToAnyPublisher()
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension AnyPublisher {
  public func bindValue<S: Subject>(
    subject: S
  ) -> AnyCancellable where S.Output == Output?, S.Failure == Failure {
    sink { completion in
      /// don't send completion
      /// subject.send(completion: completion)
    } receiveValue: { ouput in
      subject.send(ouput)
    }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension AnyPublisher where Failure == Never {
  func start() -> Cancellable {
    return sink(receiveValue: { _ in })
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension CurrentValueSubject {
  public func commit(_ block: (inout Output) -> Void) {
    var clone = self.value
    block(&clone)
    self.value = clone
  }
}

#if canImport(SwiftUI)
import SwiftUI
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension CurrentValueSubject {
  public func binding() -> Binding<Output> {
    Binding {
      self.value
    } set: { newValue, transaction in
      withTransaction(transaction) {
        self.value = newValue
      }
    }
  }
}
#endif

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
  /// Convert this publisher into an `AsyncThrowingStream` that
  /// can be iterated over asynchronously using `for try await`.
  /// The stream will yield each output value produced by the
  /// publisher and will finish once the publisher completes.
  var valuesAsync: AsyncThrowingStream<Output, Error> {
    AsyncThrowingStream { continuation in
      var cancellable: AnyCancellable?
      let onTermination = { cancellable?.cancel() }
      
      continuation.onTermination = { @Sendable _ in
        onTermination()
      }
      
      cancellable = sink(
        receiveCompletion: { completion in
          switch completion {
            case .finished:
              continuation.finish()
            case .failure(let error):
              continuation.finish(throwing: error)
          }
        }, receiveValue: { value in
          continuation.yield(value)
        }
      )
    }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher where Failure == Never {
  /// Converts publisher to AsyncSequence
  public var valuesAsync: any AsyncSequence {
    if #available(iOS 15, macOS 12, tvOS 15, watchOS 8, *) {
      return values
    } else {
      return _AsyncPublisher(self)
    }
  }
}

/// AsyncSequence from a Publisher that never errors.
/// Combine.AsyncPublisher is used when available, otherwise AsyncStream is used.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private struct _AsyncPublisher<P>: AsyncSequence where P: Publisher, P.Failure == Never {
  typealias Element = P.Output
  
  private let publisher: P
  init(_ publisher: P) {
    self.publisher = publisher
  }
  
  func makeAsyncIterator() -> Iterator {
    if #available(iOS 15, macOS 12, tvOS 15, watchOS 8, *) {
      var iterator = Combine.AsyncPublisher(publisher).makeAsyncIterator()
      return Iterator { await iterator.next() }
    } else {
      var iterator = makeAsyncStream().makeAsyncIterator()
      return Iterator { await iterator.next() }
    }
  }
  
  struct Iterator: AsyncIteratorProtocol {
    let _next: () async -> P.Output?
    
    mutating func next() async -> P.Output? {
      await _next()
    }
  }
  
  private func makeAsyncStream() -> AsyncStream<Element> {
    AsyncStream(Element.self, bufferingPolicy: .bufferingOldest(1)) { continuation in
      publisher.receive(subscriber: Inner(continuation: continuation))
    }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension _AsyncPublisher {
  final class Inner: Subscriber {
    typealias Continuation = AsyncStream<Input>.Continuation
    private var subscription: Subscription?
    private let continuation: Continuation
    
    init(continuation: Continuation) {
      self.continuation = continuation
      continuation.onTermination =  { termination in
        self.cancel(termination)
      }
    }
    
    func receive(subscription: Subscription) {
      self.subscription = subscription
      subscription.request(.max(1))
    }
    
    func receive(_ input: Element) -> Subscribers.Demand {
      continuation.yield(input)
      Task { [subscription] in
        subscription?.request(.max(1))
      }
      return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
      subscription = nil
      continuation.finish()
    }
    
    func cancel(_: Continuation.Termination) {
      subscription?.cancel()
      subscription = nil
    }
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
  public var results: AsyncStream<Result<Output, Failure>> {
    AsyncStream { continuation in
      let cancellable = map(Result.success)
        .catch { Just(.failure($0)) }
        .sink(
          receiveCompletion: { _ in
            continuation.finish()
          },
          receiveValue: { result in
            continuation.yield(result)
          }
        )
      
      continuation.onTermination = { termination in
        switch termination {
          case .cancelled:
            cancellable.cancel()
            
          case .finished:
            break
            
          @unknown default:
            break
        }
      }
    }
  }
}
#endif
