#if canImport(Combine)
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct ObservableListener {
  
  private let viewModel = ViewModel()
  
  public init() {
    
  }
  
  public var wrappedValue: Self {
    self
  }
  
  public var projectedValue: ObservableEvent {
    viewModel.observableEvent
  }
  
  public var publisher: ObservableEvent {
    viewModel.observableEvent
  }
  
  public var objectWillChange: AnyPublisher<Void, Never> {
    viewModel.observableEvent.eraseToAnyPublisher()
  }
  
  public func send() {
    viewModel.send()
  }
  
  public func sink(_ receiveValue: @escaping () -> Void) {
    viewModel.observableEvent.sink(receiveValue: receiveValue)
      .store(in: &viewModel.cancellables)
  }
  
  public func sink(_ receiveValue: @escaping () async -> Void) {
    viewModel.observableEvent.sink { action in
      Task {
        await receiveValue()
      }
    }
    .store(in: &viewModel.cancellables)
  }
  
  public func sink(_ receiveValue: @escaping () async throws -> Void) {
    viewModel.observableEvent.sink { action in
      Task {
        try await receiveValue()
      }
    }
    .store(in: &viewModel.cancellables)
  }
  
  public func onAction(_ onAction: @escaping () -> Void) {
    sink(onAction)
  }
  
  public func onAction(_ onAction: @escaping () async -> Void) {
    sink(onAction)
  }
  
  public func onAction(_ onAction: @escaping () async throws -> Void) {
    sink(onAction)
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension ObservableListener {
  /// ViewModel
  fileprivate final class ViewModel {
    
    fileprivate let observableEvent = ObservableEvent()
    
    fileprivate var cancellables = SetCancellables()
    
    deinit {
      for cancellable in cancellables {
        cancellable.cancel()
      }
    }
    
    fileprivate func send() {
      observableEvent.send()
    }
  }
}
#endif
