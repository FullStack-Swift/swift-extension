# ConvertSwift

A description of this package.

## String

```swift
//convert to Int

let string: String = "10"
let int: Int? = string.toInt() // int == Optional(10)

let string: String = "swift"
let int: Int? = string.toInt() // int == nil
```

```swift
//convert to Double

let string: String = "3.14"
let double: Double? = string.toDouble() // double == Optional(3.14)

let string: String = "swift"
let double: Double? = string.toDouble() // double == nil
```

```swift
//convert to Float

let string: String = "3.14"
let float: Float? = string.toFloat() // float == Optional(3.14)

let string: String = "swift"
let float: Float? = string.toFloat() // float == nil
```

```swift
//convert to Bool

let string: String = "true"
let bool: Bool = string.toBool() // bool == true

let string: String = "1"
let bool: Bool = string.toBool() // bool == true

let string: String = "swift"
let bool: Bool = string.toBool() // bool == false
```

```swift
//convert to URL

let string: String = ""
let url: URL? = string.toURL()
```

```swift
//convert to UUID

let string: String = ""
let uuid: UUID? = string.toUUID()
```

## Double

```swift
//convert to Int

let double: Double = 3.14
let int = double.toInt() // int == 3
```

```swift
// convert to Int

let double: Double = 3.14
let string = double.toString() // string == "3.14"
```

```swift
//convert to Float
let double: Double = 3.14
let float: Float = double.toFloat() // float == 3.14

```

## Int

```swift
//convert to Double

let int: Int = 100
let double: Double = int.toDouble() // double = 100.0
```

```swift
//convert to Float

let int: Int = 100
let float: Float = int.toFloat() // float == 100.0
```


```swift
//convert to String

let int: Int = 100
let string: String = int.toString() // string == "100"
```

## Float

```swift
//convert to String

let float: FLoat = 3.14
let string: String = float.toString() // string == "3.14"
```

```swift
//convert to Double

let float: FLoat = 3.14
let double: Double = float.toDouble() // double == 3.14
```

```swift
//convert to Int

let float: FLoat = 3.14
let int: Int = float.toInt() // int == 3
```

## UUID

```swift
//convert to String

let uuid: UUID = UUID()
let uuidString: String = uuid.toString()
```

## URL

```swift
//convert to String

let url: URL! // = something
let urlString: String = url.toString()
```

## MIX

```swift

let string: String = "3.14"
let value = string.toDouble()?.toInt().toString().....

```

# MIX DATA

```swift

struct Model: Codable {

}

//or

class Model: Codable {

}

// or

enum Model: Codable {

}

```

## Dictionary

```swift

let dict: [String: Any] = [:] // something

if let model = dict.toModel(Model.self) {

}

if let string = dict.toString() {

}

if let data = dict.toData() {

}

```

## String

```swift

let string: String = "" // something

if let dict = string.toDictionary() {

}

if let model = string.toModel(Model.self) {

}

if let data = string.toData() {

}

```

## Data

```swift

let data: Data = // something
if let dict = data.toDictionary() {

}

if let string = data.toString() {

}

if let model = data.toModel(Model.self) {

}

if let data = data.toData(keyPath: "result") {

}

```

***

## Bonous
```swift

if let value = string.toDictionary().toData().toData(keyPath: "result")... {
    // to do something
}

// clone Model
let value = model.toData().toModel(Model.self) {

}

//convert model to Data
if let data = model.toData() {

}

// convert Model to String
if let string = model.toString() {

}

//convert Model to Dictionary
if let dict = model.toDictionary() {

}

```
```
DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
February 2021

Copyright (C) 2021 Mike Packard <nguyenphong.mobile.engineer@gmail.com>

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
```
