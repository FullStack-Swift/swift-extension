import SwiftUI
import Combine

// MARK: DisposeObservable

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
open class DisposeObservable: ObservableObject {
  
  open var dispose: (() -> ())?
  
  public init(_ dispose: (() -> ())? = nil) {
    self.dispose = dispose
  }
  
  deinit {
    let clone = dispose
    dispose = nil
    Task { @MainActor in
      try await Task.sleep(seconds: 0.03)
      clone?()
    }
  }
}
