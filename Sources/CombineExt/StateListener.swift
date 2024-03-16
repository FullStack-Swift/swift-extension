#if canImport(Combine) && canImport(SwiftUI)
import Combine
import SwiftUI

// MARK: @propertyWrapper - StateListener

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct StateListener<State> {
  
  private let viewModel: ViewModel
  
  public init(wrappedValue: State) {
    viewModel = ViewModel(wrappedValue)
  }
  
  public var wrappedValue: State {
    viewModel.stateSubject.value
  }
  
  public var projectedValue: SwiftUI.Binding<State> {
    Binding {
      viewModel.stateSubject.value
    } set: { newValue, transaction in
      withTransaction(transaction) {
        viewModel.stateSubject.value = newValue
      }
    }
  }
  
  /// the publisher State
  public var publisher: StateSubject<State> {
    viewModel.stateSubject
  }
  
  /// send state to StateListener
  /// - Parameter action: the state send to StateListener
  public func send(_ state: State) {
    viewModel.send(state)
  }
  
  /// Sink action from send(_ state: State)
  /// - Parameter receiveValue: callback State
  public func sink(_ receiveValue: @escaping (State) -> Void) {
    viewModel.stateSubject.sink(receiveValue: receiveValue)
      .store(in: &viewModel.cancellables)
  }
  
  /// Sink state from send(_ state: State)
  /// - Parameter onState: callback State
  public func onState(_ onState: @escaping (State) -> Void) {
    sink(onState)
  }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension StateListener {
  
  fileprivate final class ViewModel {
    
    fileprivate let stateSubject: StateSubject<State>
    
    fileprivate var cancellables = SetCancellables()
    
    fileprivate init(_ initialValue: State) {
      stateSubject = StateSubject(initialValue)
    }
    
    deinit {
      for cancellable in cancellables {
        cancellable.cancel()
      }
    }
    
    fileprivate func send(_ state: State) {
      stateSubject.send(state)
    }
  }
}

#endif
