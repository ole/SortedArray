# SortedArray

A sorted array type written in Swift 3.0.

Provides the `SortedArray` type, an array that keeps its elements sorted according to a given sort predicate.

Written by Ole Begemann, February 2017.

For more info, see my accompanying [blog article](https://blog/2017/02/sorted-array/).

## Usage

Clone the repository and add or copy `SortedArray.swift` to your project. It has no dependencies.

If you want to try this out in a Swift Package Manager project, add this to your `Package.swift` file:

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

## Dependencies

None.

## Licence

[MIT licence](https://github.com/ole/SortedArray/blob/master/LICENSE.txt).
