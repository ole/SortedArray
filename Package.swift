// swift-tools-version:4.0
import PackageDescription

/// Provides the `SortedArray` type, an array that keeps its elements
/// sorted according to a given sort predicate.
///
/// - Author: Ole Begemann
/// - Seealso: https://github.com/ole/SortedArray
/// - Seealso: https://blog/2017/02/sorted-array/
/// - Dependencies:
///   - [SwiftCheck](https://github.com/typelift/SwiftCheck) (only for the tests)
///
let package = Package(
    name: "SortedArray",
    products: [
        .library(name: "SortedArray", targets: ["SortedArray"]),
    ],
    dependencies: [
        // Only used for the tests
        .package(url: "https://github.com/typelift/SwiftCheck", from: "0.9.1")
    ],
    targets: [
        .target(name: "SortedArray", dependencies: [], path: "Sources"),
        .testTarget(name: "SortedArrayTests", dependencies: ["SortedArray", "SwiftCheck"]),
    ],
    swiftLanguageVersions: [3, 4]
)
