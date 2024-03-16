// MARK: Base typealias function

public typealias TransformFunction<Input, Output> = (Input) -> Output

public typealias OutputFunction<Output> = () -> Output

public typealias InputFunction<Input> = (Input) -> ()

public typealias VoidFunction = () -> ()


// MARK: Base typealias async function

public typealias TransformAsyncFunction<Input, Output> = (Input) async -> Output

public typealias OutputAsyncFunction<Output> = () async -> Output

public typealias InputAsyncFunction<Input> = (Input) async -> ()

public typealias VoidAsyncFunction = () async -> ()

// MARK: Base typealias main async throwing function

public typealias TransformAsyncThrowingFunction<Input, Output> = (Input) async throws -> Output

public typealias OutputAsyncThrowingFunction<Output> = () async throws -> Output

public typealias InputAsyncThrowingFunction<Input> = (Input) async throws -> ()

public typealias VoidAsyncThrowingFunction = () async throws -> ()

// MARK: block Transform
public func blockBuilder<Input, Output>(
  _ block: @escaping TransformFunction<Input, Output>
) -> TransformFunction<Input, Output> {
  block
}

public func blockBuilder<Input, Output>(
  _ block: @escaping TransformAsyncFunction<Input, Output>
) -> TransformAsyncFunction<Input, Output> {
  block
}

public func blockBuilder<Input, Output>(
  _ block: @escaping TransformAsyncThrowingFunction<Input, Output>
) -> TransformAsyncThrowingFunction<Input, Output> {
  block
}

// MARK: block ouput
public func blockBuilder<Output>(
  _ block: @escaping OutputFunction<Output>
) -> OutputFunction<Output> {
  block
}

public func blockBuilder<Output>(
  _ block: @escaping OutputAsyncFunction<Output>
) -> OutputAsyncFunction<Output> {
  block
}

public func blockBuilder<Output>(
  _ block: @escaping OutputAsyncThrowingFunction<Output>
) -> OutputAsyncThrowingFunction<Output> {
  block
}

// MARK: block input
public func blockBuilder<Input>(
  _ block: @escaping InputFunction<Input>
) -> InputFunction<Input> {
  block
}

public func blockBuilder<Input>(
  _ block: @escaping InputAsyncFunction<Input>
) -> InputAsyncFunction<Input> {
  block
}

public func blockBuilder<Input>(
  _ block: @escaping InputAsyncThrowingFunction<Input>
) -> InputAsyncThrowingFunction<Input> {
  block
}

// MARK: block void
public func blockBuilder(
  _ block: @escaping VoidFunction
) -> VoidFunction {
  block
}

public func blockBuilder(
  _ block: @escaping VoidAsyncFunction
) -> VoidAsyncFunction {
  block
}

public func blockBuilder(
  _ block: @escaping VoidAsyncThrowingFunction
) -> VoidAsyncThrowingFunction {
  block
}
