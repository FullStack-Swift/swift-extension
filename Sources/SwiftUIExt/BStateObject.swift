import SwiftUI
import Combine

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@propertyWrapper
public struct BStateObject<Wrapped: ObservableObject>: DynamicProperty {
  
  @State private var state = Wrapper()
  
  @ObservedObject private var observedObject = Wrapper()
  
  private var thunk: () -> Wrapped
  
  /// The underlying value referenced by the state object.
  ///
  /// The wrapped value property provides primary access to the value's data.
  /// However, you don't access `wrappedValue` directly. Instead, use the
  /// property variable created with the `@_StateObject` attribute:
  ///
  ///     @_StateObject var contact = Contact()
  ///
  ///     var body: some View {
  ///         Text(contact.name) // Accesses contact's wrapped value.
  ///     }
  ///
  /// When you change a property of the wrapped value, you can access the new
  /// value immediately. However, SwiftUI updates views displaying the value
  /// asynchronously, so the user interface might not update immediately.
  public var wrappedValue: Wrapped {
    if let object = state.value {
      return object
    } else {
      let object = thunk()
      state.value = object
      return object
    }
  }
  
  /// A projection of the state object that creates bindings to its
  /// properties.
  ///
  /// Use the projected value to pass a binding value down a view hierarchy.
  /// To get the projected value, prefix the property variable with `$`. For
  /// example, you can get a binding to a model's `isEnabled` Boolean so that
  /// a ``SwiftUI/Toggle`` view can control the value:
  ///
  ///     struct MyView: View {
  ///         @_StateObject var model = DataModel()
  ///
  ///         var body: some View {
  ///             Toggle("Enabled", isOn: $model.isEnabled)
  ///         }
  ///     }
  public var projectedValue: ObservedObject<Wrapped>.Wrapper {
    ObservedObject(wrappedValue: wrappedValue).projectedValue
  }
  
  /// Creates a new state object with an initial wrapped value.
  ///
  /// You don’t call this initializer directly. Instead, declare a property
  /// with the `@_StateObject` attribute in a ``SwiftUI/View``,
  /// ``SwiftUI/App``, or ``SwiftUI/Scene``, and provide an initial value:
  ///
  ///     struct MyView: View {
  ///         @_StateObject var model = DataModel()
  ///
  ///         // ...
  ///     }
  ///
  /// SwiftUI creates only one instance of the state object for each
  /// container instance that you declare. In the code above, SwiftUI
  /// creates `model` only the first time it initializes a particular instance
  /// of `MyView`. On the other hand, each different instance of `MyView`
  /// receives a distinct copy of the data model.
  ///
  /// - Parameter thunk: An initial value for the state object.
  public init(wrappedValue thunk: @autoclosure @escaping () -> Wrapped) {
    self.thunk = thunk
  }
  
  public mutating func update() {
    if state.value == nil {
      state.value = thunk()
    }
    if observedObject.value !== state.value {
      observedObject.value = state.value
    }
  }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension BStateObject {
  private final class Wrapper: ObservableObject {
    
    private var subject = PassthroughSubject<Void, Never>()
    
    var value: Wrapped? {
      didSet {
        cancellable = nil
        cancellable = value?.objectWillChange
          .sink { [subject] _ in subject.send() }
      }
    }
    
    private var cancellable: AnyCancellable?
    
    var objectWillChange: AnyPublisher<Void, Never> {
      subject.eraseToAnyPublisher()
    }
  }
}
