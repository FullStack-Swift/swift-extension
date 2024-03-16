#if canImport(Combine)
import Combine

// MARK: @propertyWrapper - ActionListener

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct ActionListener<Action> {
  
  private let viewModel: ViewModel
  
  public init() {
    viewModel = ViewModel()
  }
  
  public var wrappedValue: Self {
    self
  }
  
  public var projectedValue: ActionSubject<Action> {
    viewModel.actionSubject
  }
  
  /// the publisher ActionListener
  public var publisher: ActionSubject<Action> {
    viewModel.actionSubject
  }
  
  public var objectWillChange: AnyPublisher<Void, Never> {
    viewModel.actionSubject.map{ _ in }.eraseToAnyPublisher()
  }
  
  /// send action to IOAction
  /// - Parameter action: the action send to ActionListener
  public func send(_ action: Action) {
    viewModel.send(action)
  }
  
  /// Sink action from send(_ action: Action)
  /// - Parameter receiveValue: callback Action
  public func sink(_ receiveValue: @escaping (Action) -> Void) {
    viewModel.actionSubject.sink(receiveValue: receiveValue)
      .store(in: &viewModel.cancellables)
  }
  
  public func sink(_ receiveValue: @escaping (Action) async throws -> Void) {
    viewModel.actionSubject.sink { action in
      Task {
        try await receiveValue(action)
      }
    }
    .store(in: &viewModel.cancellables)
  }
  
  /// Sink action from send(_ action: Action)
  /// - Parameter onAction: callback Action
  public func onAction(_ onAction: @escaping (Action) -> Void) {
    sink(onAction)
  }
  
  public func onAction(_ onAction: @escaping (Action)  async throws -> Void) {
    sink(onAction)
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension ActionListener {
  
  fileprivate final class ViewModel {
    
    fileprivate let actionSubject = ActionSubject<Action>()
    
    fileprivate var cancellables = SetCancellables()
    
    var action: Action?
    
    var observableEvent: AnyPublisher<Void, Never> {
      actionSubject.map { _ in }.eraseToAnyPublisher()
    }
    
    fileprivate init() {
      actionSubject
        .sink {
          self.action = $0
        }
        .store(in: &cancellables)
    }
    
    deinit {
      cancellables.dispose()
    }
    
    fileprivate func send(_ action: Action) {
      actionSubject.send(action)
    }
  }
}

#endif
