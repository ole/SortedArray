import SortedArray
import SwiftCheck
import XCTest

class PropertyBasedTests: XCTestCase {
    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            #if swift(>=4.0)
                let darwinTestCount = PropertyBasedTests.defaultTestSuite.testCaseCount
            #else
                let darwinTestCount = Int(PropertyBasedTests.defaultTestSuite().testCaseCount)
            #endif
            let linuxTestCount = PropertyBasedTests.allTests.count
            XCTAssertEqual(linuxTestCount, darwinTestCount, "allTests (used for testing on Linux) is missing \(darwinTestCount - linuxTestCount) tests")
        #endif
    }

    func testSwiftCheck() {
        // Uncomment this to replay SwiftCheck with a specific seed
        //let replayArgs = CheckerArguments(replay: (StdGen(1391985334, 382376411), 100))

        property("SortedArray is always sorted") <- forAll { (xs: ArrayOf<Int>) in
            let sut = SortedArray(unsorted: xs.getArray)
            return xs.getArray.sorted() == Array(sut)
        }
        property("SortedArray respects custom comparison function") <- forAll { (xs: ArrayOf<Int>) in
            let sut = SortedArray(unsorted: xs.getArray, areInIncreasingOrder: >)
            return xs.getArray.sorted(by: >) == Array(sut)
        }
        property("SortedArray remains sorted after inserting") <- forAll { (xs: ArrayOf<Int>) in
            var sut = SortedArray<Int>()
            for x in xs.getArray {
                sut.insert(x)
            }
            return xs.getArray.sorted() == Array(sut)
        }
        property("index(of:) finds first index") <- forAll { (x: Int, xs: ArrayOf<Int>) in
            let sut = SortedArray(unsorted: xs.getArray)
            return xs.getArray.sorted().index(of: x) == sut.index(of: x)
        }
        property("lastIndex(of:) finds last index") <- forAll { (x: Int, xs: ArrayOf<Int>) in
            let sut = SortedArray(unsorted: xs.getArray)
            // Array doesn't have a lastIndex(of:) method -> replicate it
            let array = xs.getArray.sorted()
            let lastIndex: Array<Int>.Index?
            if let idx = array.reversed().index(of: x)?.base {
                lastIndex = array.index(before: idx)
            } else {
                lastIndex = nil
            }
            return lastIndex == sut.lastIndex(of: x)
        }
    }
}

extension PropertyBasedTests {
    static var allTests : [(String, (PropertyBasedTests) -> () throws -> Void)] {
        return [
            ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
            ("testSwiftCheck", testSwiftCheck),
        ]
    }
}

