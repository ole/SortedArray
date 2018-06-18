// swift-tools-version:4.0
import PackageDescription

/// Provides the `SortedArray` type, an array that keeps its elements
/// sorted according to a given sort predicate.
///
/// - Author: Ole Begemann
/// - Seealso: https://github.com/ole/SortedArray
/// - Seealso: https://blog/2017/02/sorted-array/
///
let package = Package(
    name: "SortedArray",
    products: [
        .library(
            name: "SortedArray",
            targets: ["SortedArray"]),
    ],
    targets: [
        .target(
            name: "SortedArray",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "UnitTests",
            dependencies: ["SortedArray"]),
        .testTarget(
            name: "PerformanceTests",
            dependencies: ["SortedArray"]),
    ],
    swiftLanguageVersions: [4]
)
