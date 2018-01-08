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
}

extension PerformanceTests {
    static var allTests : [(String, (PerformanceTests) -> () throws -> Void)] {
        return [
            ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
            ("testPerformanceOfIndexOf", testPerformanceOfIndexOf),
            ("testPerformanceOfLastIndexOf", testPerformanceOfLastIndexOf),
        ]
    }
}
