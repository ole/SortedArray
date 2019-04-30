import SortedArray
import XCTest

class PerformanceTests: XCTestCase {
    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            let darwinTestCount = PerformanceTests.defaultTestSuite.testCaseCount
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

    func testPerformanceOfFirstIndexWhere() {
        let sourceArray = Array(repeating: 500, count: 1_000_000) + Array(repeating: 40, count: 1_000_000) + Array(repeating: 3, count: 1_000_000)
        let sut = SortedArray(unsorted: sourceArray)
        measure {
            XCTAssertEqual(sut.firstIndex(where: { $0 >= 500 }), 2_000_000)
        }
    }

    func testPerformanceOfLastIndexWhere() {
        let sourceArray = Array(repeating: 500, count: 1_000_000) + Array(repeating: 40, count: 1_000_000) + Array(repeating: 3, count: 1_000_000)
        let sut = SortedArray(unsorted: sourceArray)
        measure {
            XCTAssertEqual(sut.lastIndex(where: { $0 <= 3 }), 999_999)
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

    func testPerformanceOfFirstIndexWhereObject() {
        let sourceArray = Array(repeating: Box(500), count: 1_000_000) + Array(repeating: Box(40), count: 1_000_000) + Array(repeating: Box(3), count: 1_000_000)
        let sut = SortedArray(unsorted: sourceArray)
        measure {
            XCTAssertEqual(sut.firstIndex(where: { $0 >= Box(500) }), 2_000_000)
        }
    }

    func testPerformanceOfLastIndexWhereObject() {
        let sourceArray = Array(repeating: Box(500), count: 1_000_000) + Array(repeating: Box(40), count: 1_000_000) + Array(repeating: Box(3), count: 1_000_000)
        let sut = SortedArray(unsorted: sourceArray)
        measure {
            XCTAssertEqual(sut.lastIndex(where: { $0 <= Box(3) }), 999_999)
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

    func testPerformanceOfFirstIndexWhereObjectInRange() {
        let sut = SortedArray(sorted: (0..<3_000_000).lazy.map(Box.init))
        measure {
            XCTAssertEqual(sut.firstIndex(where: { $0 >= Box(500) }), 500)
        }
    }

    func testPerformanceOfLastIndexWhereObjectInRange() {
        let sut = SortedArray(sorted: (0..<3_000_000).lazy.map(Box.init))
        measure {
            XCTAssertEqual(sut.lastIndex(where: { $0 <= Box(1_999_999) }), 1_999_999)
        }
    }
}

extension PerformanceTests {
    static var allTests : [(String, (PerformanceTests) -> () throws -> Void)] {
        return [
            ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
            ("testPerformanceOfIndexOf", testPerformanceOfIndexOf),
            ("testPerformanceOfLastIndexOf", testPerformanceOfLastIndexOf),
            ("testPerformanceOfFirstIndexWhere", testPerformanceOfFirstIndexWhere),
            ("testPerformanceOfLastIndexWhere", testPerformanceOfLastIndexWhere),
            ("testPerformanceOfIndexOfObject", testPerformanceOfIndexOfObject),
            ("testPerformanceOfLastIndexOfObject", testPerformanceOfLastIndexOfObject),
            ("testPerformanceOfFirstIndexWhereObject", testPerformanceOfFirstIndexWhereObject),
            ("testPerformanceOfLastIndexWhereObject", testPerformanceOfLastIndexWhereObject),
            ("testPerformanceOfIndexOfObjectInRange", testPerformanceOfIndexOfObjectInRange),
            ("testPerformanceOfLastIndexOfObjectInRange", testPerformanceOfLastIndexOfObjectInRange),
            ("testPerformanceOfFirstIndexWhereObjectInRange", testPerformanceOfFirstIndexWhereObjectInRange),
            ("testPerformanceOfLastIndexWhereObjectInRange", testPerformanceOfLastIndexWhereObjectInRange),
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
