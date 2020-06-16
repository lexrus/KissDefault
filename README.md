# 💋 KissDefault

![Language](https://img.shields.io/badge/language-Swift%205.2-orange)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

> Keep It(UserDefaults propertyWrapper) Simple and Stupid

KissDefault is a polished propertyWrapper which minimize the boilerplate of writing property keys. If you have no idea of what propertyWrapper is, please head to [Property wrappers in Swift](https://www.swiftbysundell.com/articles/property-wrappers-in-swift/).


### The old redundant way

```swift
// You have to define every key name by yourself, seriously?
@UserDefaultsBacked(key: "signature")
var messageSignature: String?

@UserDefaultsBacked(key: "mark-as-read", defaultValue: true)
var autoMarkMessagesAsRead: Bool

@UserDefaultsBacked(key: "search-page-size", defaultValue: 20)
var numberOfSearchResultsPerPage: Int
```

### With KissDefault

```swift
@Kiss()
var messageSignature: String?

@Kiss(default: true)
var autoMarkMessagesAsRead: Bool

@Kiss(default: 20)
var numberOfSearchResultsPerPage: Int
```

### You can even benefit from Codable protocol

```swift
struct ObjStruct: Equatable, Codable {
    var wrappedValue: Int = 1024

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
...
@Kiss()
static var objV1: ObjStruct?
```

### How it works

KissDefault extracts the current callstack in `wrappedValue` (with `Thread.callStackSymbols`), demangles the presented variable name and use it as the key to store values. This process is done by a simple regex which may not be a performance concern. Please read [this article](https://www.cocoawithlove.com/blog/2016/05/01/swift-name-demangling.html) if you're interested in demangling in Swift.

### Todos

- [ ] CocoaPods
- [ ] Customized key
- [ ] Boost demangle performance


## License

This code is distributed under the terms and conditions of the MIT license.
