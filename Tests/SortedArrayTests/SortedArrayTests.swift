import SortedArray
import XCTest

class SortedArrayTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            let darwinTestCount = Int(SortedArrayTests.defaultTestSuite().testCaseCount)
            let linuxTestCount = SortedArrayTests.allTests.count
            XCTAssertEqual(linuxTestCount, darwinTestCount, "allTests (used for testing on Linux) is missing \(darwinTestCount - linuxTestCount) tests")
        #endif
    }

    func testInitUnsortedSorts() {
        let sut = SortedArray(unsorted: [3,4,2,1], areInIncreasingOrder: <)
        assertElementsEqual(sut, [1,2,3,4])
    }

    func testInitSortedDoesntResort() {
        // Warning: this is not a valid way to create a SortedArray
        let sut = SortedArray(sorted: [3,2,1])
        assertElementsEqual(Array(sut), [3,2,1])
    }

    func testSortedArrayCanUseArbitraryComparisonPredicate() {
        struct Person {
            var firstName: String
            var lastName: String
        }
        let a = Person(firstName: "A", lastName: "Smith")
        let b = Person(firstName: "B", lastName: "Jones")
        let c = Person(firstName: "C", lastName: "Lewis")

        var sut = SortedArray<Person> { $0.firstName > $1.firstName }
        sut.insert(contentsOf: [b,a,c])
        assertElementsEqual(sut.map { $0.firstName }, ["C","B","A"])
    }

    func testConvenienceInitsUseLessThan() {
        let sut = SortedArray(unsorted: ["a","c","b"])
        assertElementsEqual(sut, ["a","b","c"])
    }

    func testInsertAtBeginningPreservesSortOrder() {
        var sut = SortedArray(unsorted: 1...3)
        sut.insert(0)
        assertElementsEqual(sut, [0,1,2,3])
    }

    func testInsertInMiddlePreservesSortOrder() {
        var sut = SortedArray(unsorted: 1...5)
        sut.insert(4)
        assertElementsEqual(sut, [1,2,3,4,4,5])
    }

    func testInsertAtEndPreservesSortOrder() {
        var sut = SortedArray(unsorted: 1...3)
        sut.insert(5)
        assertElementsEqual(sut, [1,2,3,5])
    }

    func testInsertAtBeginningReturnsInsertionIndex() {
        var sut = SortedArray(unsorted: [1,2,3])
        let index = sut.insert(0)
        XCTAssertEqual(index, 0)
    }

    func testInsertInMiddleReturnsInsertionIndex() {
        var sut = SortedArray(unsorted: [1,2,3,5])
        let index = sut.insert(4)
        XCTAssertEqual(index, 3)
    }

    func testInsertAtEndReturnsInsertionIndex() {
        var sut = SortedArray(unsorted: [1,2,3])
        let index = sut.insert(100)
        XCTAssertEqual(index, 3)
    }

    func testInsertInEmptyArrayReturnsInsertionIndex() {
        var sut = SortedArray<Int>()
        let index = sut.insert(10)
        XCTAssertEqual(index, 0)
    }

    func testInsertEqualElementReturnsCorrectInsertionIndex() {
        var sut = SortedArray(unsorted: [3,1,0,2,1])
        let index = sut.insert(1)
        XCTAssert(index == 1 || index == 2 || index == 3)
    }

    func testInsertContentsOfPreservesSortOrder() {
        var sut = SortedArray(unsorted: [10,9,8])
        sut.insert(contentsOf: (7...11).reversed())
        assertElementsEqual(sut, [7,8,8,9,9,10,10,11])
    }

    func testIndexOfFindsElementInMiddle() {
        let sut = SortedArray(unsorted: ["a","z","r","k"])
        let index = sut.index(of: "k")
        XCTAssertEqual(index, 1)
    }

    func testIndexOfFindsFirstElement() {
        let sut = SortedArray(sorted: 1..<10)
        let index = sut.index(of: 1)
        XCTAssertEqual(index, 0)
    }

    func testIndexOfFindsLastElement() {
        let sut = SortedArray(sorted: 1..<10)
        let index = sut.index(of: 9)
        XCTAssertEqual(index, 8)
    }

    func testIndexOfReturnsNilWhenNotFound() {
        let sut = SortedArray(unsorted: "Hello World".characters)
        let index = sut.index(of: "h")
        XCTAssertNil(index)
    }

    func testIndexOfReturnsFirstMatchForDuplicates() {
        let sut = SortedArray(unsorted: "abcabcabc".characters)
        let index = sut.index(of: "c")
        XCTAssertEqual(index, 6)
    }

    func testsContains() {
        let sut = SortedArray(unsorted: "Lorem ipsum".characters)
        XCTAssertTrue(sut.contains(" "))
        XCTAssertFalse(sut.contains("a"))
    }

    func testMin() {
        let sut = SortedArray(unsorted: -10...10)
        XCTAssertEqual(sut.min(), -10)
    }

    func testMax() {
        let sut = SortedArray(unsorted: -10...(-1))
        XCTAssertEqual(sut.max(), -1)
    }

    func testCustomStringConvertible() {
        let sut = SortedArray(unsorted: ["a", "c", "b"])
        let description = String(describing: sut)
        XCTAssertEqual(description, "[\"a\", \"b\", \"c\"] (sorted)")
    }

    func testCustomDebugStringConvertible() {
        let sut = SortedArray(unsorted: ["a", "c", "b"])
        let description = String(reflecting: sut)
        XCTAssertEqual(description, "<SortedArray> [\"a\", \"b\", \"c\"]")
    }

    func testFilter() {
        let sut = SortedArray(unsorted: ["a", "b", "c"])
        assertElementsEqual(sut.filter { $0 != "a" }, ["b", "c"])
    }

    func testRemoveAtIndex() {
        var sut = SortedArray(unsorted: [3,4,2,1])
        let removedElement = sut.remove(at: 1)
        assertElementsEqual(sut, [1,3,4])
        XCTAssertEqual(removedElement, 2)
    }

    func testRemoveSubrange() {
        var sut = SortedArray(unsorted: ["a","d","c","b"])
        sut.removeSubrange(2..<4)
        assertElementsEqual(sut, ["a","b"])
    }

    func testRemoveFirst() {
        var sut = SortedArray(unsorted: [3,4,2,1])
        let removedElement = sut.removeFirst()
        assertElementsEqual(sut, [2,3,4])
        XCTAssertEqual(removedElement, 1)
    }

    func testRemoveFirstN() {
        var sut = SortedArray(unsorted: [3,4,2,1])
        sut.removeFirst(2)
        assertElementsEqual(sut, [3,4])
    }

    func testRemoveLast() {
        var sut = SortedArray(unsorted: [3,4,2,1])
        let removedElement = sut.removeLast()
        assertElementsEqual(sut, [1,2,3])
        XCTAssertEqual(removedElement, 4)
    }

    func testRemoveLastN() {
        var sut = SortedArray(unsorted: [3,4,2,1])
        sut.removeLast(2)
        assertElementsEqual(sut, [1,2])
    }

    func testRemoveAll() {
        var sut = SortedArray(unsorted: ["a","d","c","b"])
        sut.removeAll()
        assertElementsEqual(sut, [])
    }

    func testRemoveElementAtBeginningPreservesSortOrder() {
        var sut = SortedArray(unsorted: 1...3)
        sut.remove(1)
        assertElementsEqual(sut, [2,3])
    }

    func testRemoveElementInMiddlePreservesSortOrder() {
        var sut = SortedArray(unsorted: 1...5)
        sut.remove(4)
        assertElementsEqual(sut, [1,2,3,5])
    }

    func testRemoveElementAtEndPreservesSortOrder() {
        var sut = SortedArray(unsorted: 1...3)
        sut.remove(3)
        assertElementsEqual(sut, [1,2])
    }
}

extension SortedArrayTests {
    static var allTests : [(String, (SortedArrayTests) -> () throws -> Void)] {
        return [
            ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
            ("testInitUnsortedSorts", testInitUnsortedSorts),
            ("testInitSortedDoesntResort", testInitSortedDoesntResort),
            ("testSortedArrayCanUseArbitraryComparisonPredicate", testSortedArrayCanUseArbitraryComparisonPredicate),
            ("testConvenienceInitsUseLessThan", testConvenienceInitsUseLessThan),
            ("testInsertAtBeginningPreservesSortOrder", testInsertAtBeginningPreservesSortOrder),
            ("testInsertInMiddlePreservesSortOrder", testInsertInMiddlePreservesSortOrder),
            ("testInsertAtEndPreservesSortOrder", testInsertAtEndPreservesSortOrder),
            ("testInsertAtBeginningReturnsInsertionIndex", testInsertAtBeginningReturnsInsertionIndex),
            ("testInsertInMiddleReturnsInsertionIndex", testInsertInMiddleReturnsInsertionIndex),
            ("testInsertAtEndReturnsInsertionIndex", testInsertAtEndReturnsInsertionIndex),
            ("testInsertInEmptyArrayReturnsInsertionIndex", testInsertInEmptyArrayReturnsInsertionIndex),
            ("testInsertEqualElementReturnsCorrectInsertionIndex", testInsertEqualElementReturnsCorrectInsertionIndex),
            ("testInsertContentsOfPreservesSortOrder", testInsertContentsOfPreservesSortOrder),
            ("testIndexOfFindsElementInMiddle", testIndexOfFindsElementInMiddle),
            ("testIndexOfFindsFirstElement", testIndexOfFindsFirstElement),
            ("testIndexOfFindsLastElement", testIndexOfFindsLastElement),
            ("testIndexOfReturnsNilWhenNotFound", testIndexOfReturnsNilWhenNotFound),
            ("testIndexOfReturnsFirstMatchForDuplicates", testIndexOfReturnsFirstMatchForDuplicates),
            ("testsContains", testsContains),
            ("testMin", testMin),
            ("testMax", testMax),
            ("testCustomStringConvertible", testCustomStringConvertible),
            ("testCustomDebugStringConvertible", testCustomDebugStringConvertible),
            ("testFilter", testFilter),
            ("testRemoveAtIndex", testRemoveAtIndex),
            ("testRemoveSubrange", testRemoveSubrange),
            ("testRemoveFirst", testRemoveFirst),
            ("testRemoveFirstN", testRemoveFirstN),
            ("testRemoveLast", testRemoveLast),
            ("testRemoveLastN", testRemoveLastN),
            ("testRemoveAll", testRemoveAll),
            ("testRemoveElementAtBeginningPreservesSortOrder", testRemoveElementAtBeginningPreservesSortOrder),
            ("testRemoveElementInMiddlePreservesSortOrder", testRemoveElementInMiddlePreservesSortOrder),
            ("testRemoveElementAtEndPreservesSortOrder", testRemoveElementAtEndPreservesSortOrder),
        ]
    }
}
