/// A weak referencing a object.
public struct WeakObject<Node: AnyObject> {
  
  /// A current object
  public weak var ref: Node?
  
  /// Creates a new ref object whose `ref` property is initalized to the pass `ref`
  /// - Parameter ref: An initial value.
  public init(_ ref: Node?) {
    self.ref = ref
  }
  
  public init(value: Node?) {
    self.ref = value
  }
  
  public var value: Node? {
    get {
      ref
    }
    set {
      ref = newValue
    }
  }
}

extension WeakObject: Equatable where Node: Equatable {}

@dynamicMemberLookup
@propertyWrapper
public struct SWeakObject<Node: AnyObject> {
  @SRefObject<WeakObject<Node>>
  internal var _value: WeakObject<Node>
  
  public init(wrappedValue: @escaping () -> Node?) {
    _value = .init(value: wrappedValue())
  }
  
  public init(wrappedValue: Node?) {
    _value = .init(value: wrappedValue)
  }
  
  public var wrappedValue: Node? {
    get {
      _value.ref
    }
    nonmutating set {
      _value.ref = newValue
    }
  }
  
  public var projectedValue: Self {
    self
  }
  
  public var value: Node? {
    get {
      _value.value
    }
    nonmutating set {
      _value.value = newValue
    }
  }
  
  public subscript<Value: Equatable>(
    dynamicMember keyPath: WritableKeyPath<Node, Value?>
  ) -> Value? {
    get {
      _value.value?[keyPath: keyPath]
    }
    set {
      _value.value?[keyPath: keyPath] = newValue
    }
  }
}
