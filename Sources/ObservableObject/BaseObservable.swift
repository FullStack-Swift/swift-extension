import SwiftUI
import Combine

// MARK: BaseObservable

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
open class BaseObservable: ObservableObject {
  
  public private(set) lazy var objectWillChange = ObservableObjectPublisher()
  
  public var cancellables = Set<AnyCancellable>()
  
  /// On event update UI
  @ObservableListener
  public var onChange
  
  /// Send event to update UI
  @ObservableListener
  public var observable
  
  public init() {
    objectWillChange
      .eraseToAnyPublisher()
      .sink(receiveValue: onChange.send)
      .store(in: &cancellables)
    observable.publisher
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: objectWillChange.send)
      .store(in: &cancellables)
  }
  
  open func willChangeTask() {
    Task { @MainActor [weak self] in
      self?.objectWillChange.send()
    }
  }
  
  open func willChangeDispatchQueue() {
    DispatchQueue.main.async { [weak self] in
      self?.objectWillChange.send()
    }
  }
}
