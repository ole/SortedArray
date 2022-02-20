# SortedArray

A sorted array type for Swift 4.0+.

Provides the `SortedArray` type, an array that keeps its elements sorted according to a given sort predicate.

Written by Ole Begemann, February 2017.

For more info, see the [GitHub repo](https://github.com/ole/SortedArray) and my accompanying [blog article](https://oleb.net/blog/2017/02/sorted-array/).

## Supported Platforms

The current release supports Swift 4.0 and up.

If you need support for older Swift version, here's a list of the latest releases that support specific Swift versions:

| Swift version | Latest SortedArray release |
| ------------- | -------------------------- |
| 4.x           | master                     |
| 3.x           | [0.6.0](https://github.com/ole/SortedArray/releases/tag/0.6.0) |
| 3.0           | [0.4](https://github.com/ole/SortedArray/releases/tag/0.4.0)   |

Since the code has no dependencies other than the Swift standard library (it doesn't even use Foundation), it should work on all platforms where Swift is available.

I tested it on macOS, iOS, tvOS, and Linux.

## Usage

### Swift Package Manager

Add this to your `Package.swift` file:

```swift
// Package.swift
import PackageDescription

let package = Package(
    name: "<Your package name>",
    dependencies: [
        .Package(url: "https://github.com/ole/SortedArray.git", majorVersion: 0)
    ]
)
```

### Carthage

Add this to your `Cartfile`:

```
github "ole/SortedArray" ~> 0.7
```

Integration via Carthage should work for macOS, iOS, tvOS, and watchOS targets.

### Manually

Clone the repository and add or copy `SortedArray.swift` to your project. It has no dependencies.

## Dependencies

None.

## License

[MIT license](https://github.com/ole/SortedArray/blob/master/LICENSE.txt).
