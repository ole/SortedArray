import SortedArray
import XCTest

class PerformanceTests: XCTestCase {
    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            #if swift(>=4.0)
                let darwinTestCount = PerformanceTests.defaultTestSuite.testCaseCount
            #else
                let darwinTestCount = Int(PerformanceTests.defaultTestSuite().testCaseCount)
            #endif
            let linuxTestCount = PerformanceTests.allTests.count
            XCTAssertEqual(linuxTestCount, darwinTestCount, "allTests (used for testing on Linux) is missing \(darwinTestCount - linuxTestCount) tests")
        #endif
    }

    func testPerformanceOfIndexOf() {
        let sourceArray = Array(repeating: 500, count: 1_000_000) + Array(repeating: 40, count: 1_000_000) + Array(repeating: 3, count: 1_000_000)
        let sut = SortedArray(unsorted: sourceArray)
        measure {
            XCTAssertEqual(sut.index(of: 500), 2_000_000)
        }
    }

    func testPerformanceOfLastIndexOf() {
        let sourceArray = Array(repeating: 500, count: 1_000_000) + Array(repeating: 40, count: 1_000_000) + Array(repeating: 3, count: 1_000_000)
        let sut = SortedArray(unsorted: sourceArray)
        measure {
            XCTAssertEqual(sut.lastIndex(of: 3), 999_999)
        }
    }

    func testPerformanceOfIndexOfObject() {
        let sourceArray = Array(repeating: Box(500), count: 1_000_000) + Array(repeating: Box(40), count: 1_000_000) + Array(repeating: Box(3), count: 1_000_000)
        let sut = SortedArray(unsorted: sourceArray)
        measure {
            XCTAssertEqual(sut.index(of: Box(500)), 2_000_000)
        }
    }

    func testPerformanceOfLastIndexOfObject() {
        let sourceArray = Array(repeating: Box(500), count: 1_000_000) + Array(repeating: Box(40), count: 1_000_000) + Array(repeating: Box(3), count: 1_000_000)
        let sut = SortedArray(unsorted: sourceArray)
        measure {
            XCTAssertEqual(sut.lastIndex(of: Box(3)), 999_999)
        }
    }

    func testPerformanceOfIndexOfObjectInRange() {
        let sut = SortedArray(sorted: (0..<3_000_000).lazy.map(Box.init))
        measure {
            XCTAssertEqual(sut.index(of: Box(500)), 500)
        }
    }

    func testPerformanceOfLastIndexOfObjectInRange() {
        let sut = SortedArray(sorted: (0..<3_000_000).lazy.map(Box.init))
        XCTAssertEqual(sut.lastIndex(of: Box(1_999_999)), 1_999_999)
        measure {
            XCTAssertEqual(sut.lastIndex(of: Box(1_999_999)), 1_999_999)
        }
    }
}

extension PerformanceTests {
    static var allTests : [(String, (PerformanceTests) -> () throws -> Void)] {
        return [
            ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
            ("testPerformanceOfIndexOf", testPerformanceOfIndexOf),
            ("testPerformanceOfLastIndexOf", testPerformanceOfLastIndexOf),
            ("testPerformanceOfIndexOfObject", testPerformanceOfIndexOfObject),
            ("testPerformanceOfLastIndexOfObject", testPerformanceOfLastIndexOfObject),
            ("testPerformanceOfIndexOfObjectInRange", testPerformanceOfIndexOfObjectInRange),
            ("testPerformanceOfLastIndexOfObjectInRange", testPerformanceOfLastIndexOfObjectInRange),
        ]
    }
}

/// Helper class
class Box<T: Comparable>: Comparable {
    static func ==(lhs: Box<T>, rhs: Box<T>) -> Bool {
        return lhs.value == rhs.value
    }

    static func <(lhs: Box<T>, rhs: Box<T>) -> Bool {
        return lhs.value < rhs.value
    }

    let value: T
    init(_ value: T) {
        self.value = value
    }
}
