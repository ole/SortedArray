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
            let darwinTestCount = SortedArrayTests.defaultTestSuite.testCaseCount
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
//        let sut = SortedArray(sorted: [3,2,1])
//        assertElementsEqual(Array(sut), [3,2,1])
        XCTAssert(true)
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
    
    func testSortedArrayWithKeyPath() {
        var sut1 = SortedArray<String>(by: \.count)
        sut1.insert("Arthur")
        sut1.insert("Zoro")
        sut1.insert("Wax")
        assertElementsEqual(sut1, ["Wax", "Zoro", "Arthur"])

        var sut2 = SortedArray<String>(by: \.self)
        sut2.insert("Arthur")
        sut2.insert("Zoro")
        sut2.insert("Wax")
        assertElementsEqual(sut2, ["Arthur", "Wax", "Zoro"])
    }
    
    func testSortedArrayWithKeyPathSorted() {
        struct Person {
            var firstName: String
            var lastName: String
        }
        let a = Person(firstName: "A", lastName: "Smith")
        let b = Person(firstName: "B", lastName: "Jones")
        let c = Person(firstName: "C", lastName: "Lewis")
        let sut = SortedArray<Person>(sorted: [b, c, a], by: \.lastName)
        assertElementsEqual(sut.map { $0.firstName }, ["B", "C", "A"])
    }
    
    func testSortedArrayWithKeyPathUnsorted() {
        struct Person {
            var firstName: String
            var lastName: String
        }
        let a = Person(firstName: "A", lastName: "Smith")
        let b = Person(firstName: "B", lastName: "Jones")
        let c = Person(firstName: "C", lastName: "Lewis")
        let sut = SortedArray<Person>(unsorted: [a, b, c], by: \.lastName)
        assertElementsEqual(sut.map { $0.firstName }, ["B", "C", "A"])
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
        let index = sut.firstIndex(of: "k")
        XCTAssertEqual(index, 1)
    }

    func testIndexOfFindsFirstElement() {
        let sut = SortedArray(sorted: 1..<10)
        let index = sut.firstIndex(of: 1)
        XCTAssertEqual(index, 0)
    }

    func testIndexOfFindsLastElement() {
        let sut = SortedArray(sorted: 1..<10)
        let index = sut.firstIndex(of: 9)
        XCTAssertEqual(index, 8)
    }

    func testIndexOfReturnsNilWhenNotFound() {
        let sut = SortedArray(unsorted: "Hello World")
        let index = sut.firstIndex(of: "h")
        XCTAssertNil(index)
    }

    func testIndexOfReturnsNilForEmptyArray() {
        let sut = SortedArray<Int>()
        let index = sut.firstIndex(of: 1)
        XCTAssertNil(index)
    }

    func testIndexOfCanDealWithSingleElementArray() {
        let sut = SortedArray<Int>(unsorted: [5])
        let index = sut.firstIndex(of: 5)
        XCTAssertEqual(index, 0)
    }

    func testIndexOfFindsFirstIndexOfDuplicateElements1() {
        let sut = SortedArray(unsorted: [1,2,3,3,3,3,3,3,3,3,4,5])
        let index = sut.firstIndex(of: 3)
        XCTAssertEqual(index, 2)
    }

    func testIndexOfFindsFirstIndexOfDuplicateElements2() {
        let sut = SortedArray(unsorted: [1,4,4,4,4,4,4,4,4,3,2])
        let index = sut.firstIndex(of: 4)
        XCTAssertEqual(index, 3)
    }

    func testIndexOfFindsFirstIndexOfDuplicateElements3() {
        let sut = SortedArray(unsorted: String(repeating: "A", count: 10))
        let index = sut.firstIndex(of: "A")
        XCTAssertEqual(index, 0)
    }

    func testIndexOfFindsFirstIndexOfDuplicateElements4() {
        let sut = SortedArray<Character>(unsorted: Array(repeating: "a", count: 100_000))
        let index = sut.firstIndex(of: "a")
        XCTAssertEqual(index, 0)
    }

    func testIndexOfFindsFirstIndexOfDuplicateElements5() {
        let sourceArray = Array(repeating: 5, count: 100_000) + [1,2,6,7,8,9]
        let sut = SortedArray(unsorted: sourceArray)
        let index = sut.firstIndex(of: 5)
        XCTAssertEqual(index, 2)
    }

    func testIndexOfExistsAndIsAnAliasForFirstIndexOf() {
        let sut = SortedArray(unsorted: [1,2,3,3,3,3,3,3,3,3,4,5])
        let index = sut.index(of: 3)
        XCTAssertEqual(index, 2)
    }

    func testFirstIndexWhereFindsElementInMiddle() {
        let sut = SortedArray(unsorted: ["a","z","r","k"])
        let index = sut.firstIndex(where: { $0 >= "k" })
        XCTAssertEqual(index, 1)
    }

    func testFirstIndexWhereFindsFirstElement() {
        let sut = SortedArray(sorted: 1..<10)
        let index = sut.firstIndex(where: { $0 >= 1 })
        XCTAssertEqual(index, 0)
    }

    func testFirstIndexWhereFindsLastElement() {
        let sut = SortedArray(sorted: 1..<10)
        let index = sut.firstIndex(where: { $0 >= 9 })
        XCTAssertEqual(index, 8)
    }

    func testFirstIndexWhereReturnsNilWhenNotFound() {
        let sut = SortedArray(unsorted: "Hello World")
        let index = sut.firstIndex(where: { $0 > "z"})
        XCTAssertNil(index)
    }

    func testFirstIndexWhereReturnsNilForEmptyArray() {
        let sut = SortedArray<Int>()
        let index = sut.firstIndex(where: { $0 >= 1 })
        XCTAssertNil(index)
    }

    func testFirstIndexWhereCanDealWithSingleElementArray() {
        let sut = SortedArray<Int>(unsorted: [5])
        let index = sut.firstIndex(where: { $0 >= 5 })
        XCTAssertEqual(index, 0)
    }

    func testFirstIndexWhereFindsFirstIndexOfDuplicateElements1() {
        let sut = SortedArray(unsorted: [1,2,3,3,3,3,3,3,3,3,4,5])
        let index = sut.firstIndex(where: { $0 >= 3 })
        XCTAssertEqual(index, 2)
    }

    func testFirstIndexWhereFindsFirstIndexOfDuplicateElements2() {
        let sut = SortedArray(unsorted: [1,4,4,4,4,4,4,4,4,3,2])
        let index = sut.firstIndex(where: { $0 >= 4 })
        XCTAssertEqual(index, 3)
    }

    func testFirstIndexWhereFindsFirstIndexOfDuplicateElements3() {
        let sut = SortedArray(unsorted: String(repeating: "A", count: 10))
        let index = sut.firstIndex(where: { $0 >= "A" })
        XCTAssertEqual(index, 0)
    }

    func testFirstIndexWhereFindsFirstIndexOfDuplicateElements4() {
        let sut = SortedArray<Character>(unsorted: Array(repeating: "a", count: 100_000))
        let index = sut.firstIndex(where: { $0 >= "a" })
        XCTAssertEqual(index, 0)
    }

    func testFirstIndexWhereFindsFirstIndexOfDuplicateElements5() {
        let sourceArray = Array(repeating: 5, count: 100_000) + [1,2,6,7,8,9]
        let sut = SortedArray(unsorted: sourceArray)
        let index = sut.firstIndex(where: { $0 >= 5 })
        XCTAssertEqual(index, 2)
    }

    func testLastIndexOfFindsElementInMiddle() {
        let sut = SortedArray(unsorted: ["a","z","r","k"])
        let index = sut.lastIndex(of: "k")
        XCTAssertEqual(index, 1)
    }

    func testLastIndexOfFindsFirstElement() {
        let sut = SortedArray(sorted: 1..<10)
        let index = sut.lastIndex(of: 1)
        XCTAssertEqual(index, 0)
    }

    func testLastIndexOfFindsLastElement() {
        let sut = SortedArray(sorted: 1..<10)
        let index = sut.lastIndex(of: 9)
        XCTAssertEqual(index, 8)
    }

    func testLastIndexOfReturnsNilWhenNotFound() {
        let sut = SortedArray(unsorted: "Hello World")
        let index = sut.lastIndex(of: "h")
        XCTAssertNil(index)
    }

    func testLastIndexOfReturnsNilForEmptyArray() {
        let sut = SortedArray<Int>()
        let index = sut.lastIndex(of: 1)
        XCTAssertNil(index)
    }

    func testLastIndexOfCanDealWithSingleElementArray() {
        let sut = SortedArray<Int>(unsorted: [5])
        let index = sut.lastIndex(of: 5)
        XCTAssertEqual(index, 0)
    }

    func testLastIndexOfFindsLastIndexOfDuplicateElements1() {
        let sut = SortedArray(unsorted: [1,2,3,3,3,3,3,3,3,3,4,5])
        let index = sut.lastIndex(of: 3)
        XCTAssertEqual(index, 9)
    }

    func testLastIndexOfFindsLastIndexOfDuplicateElements2() {
        let sut = SortedArray(unsorted: [1,4,4,4,4,4,4,4,4,3,2])
        let index = sut.lastIndex(of: 4)
        XCTAssertEqual(index, 10)
    }

    func testLastIndexOfFindsLastIndexOfDuplicateElements3() {
        let sut = SortedArray(unsorted: String(repeating: "A", count: 10))
        let index = sut.lastIndex(of: "A")
        XCTAssertEqual(index, 9)
    }

    func testLastIndexWhereFindsElementInMiddle() {
        let sut = SortedArray(unsorted: ["a","z","r","k"])
        let index = sut.lastIndex(where: { $0 <= "k" })
        XCTAssertEqual(index, 1)
    }

    func testLastIndexWhereFindsFirstElement() {
        let sut = SortedArray(sorted: 1..<10)
        let index = sut.lastIndex(where: { $0 <= 1 })
        XCTAssertEqual(index, 0)
    }

    func testLastIndexWhereFindsLastElement() {
        let sut = SortedArray(sorted: 1..<10)
        let index = sut.lastIndex(where: { $0 <= 9 })
        XCTAssertEqual(index, 8)
    }

    func testLastIndexWhereReturnsNilWhenNotFound() {
        let sut = SortedArray(unsorted: "Hello World")
        let index = sut.lastIndex(where: { $0 < " " })
        XCTAssertNil(index)
    }

    func testLastIndexWhereReturnsNilForEmptyArray() {
        let sut = SortedArray<Int>()
        let index = sut.lastIndex(where: { $0 <= 1 })
        XCTAssertNil(index)
    }

    func testLastIndexWhereCanDealWithSingleElementArray() {
        let sut = SortedArray<Int>(unsorted: [5])
        let index = sut.lastIndex(where: { $0 <= 5 })
        XCTAssertEqual(index, 0)
    }

    func testLastIndexWhereFindsLastIndexOfDuplicateElements1() {
        let sut = SortedArray(unsorted: [1,2,3,3,3,3,3,3,3,3,4,5])
        let index = sut.lastIndex(where: { $0 <= 3 })
        XCTAssertEqual(index, 9)
    }

    func testLastIndexWhereFindsLastIndexOfDuplicateElements2() {
        let sut = SortedArray(unsorted: [1,4,4,4,4,4,4,4,4,3,2])
        let index = sut.lastIndex(where: { $0 <= 4 })
        XCTAssertEqual(index, 10)
    }

    func testLastIndexWhereFindsLastIndexOfDuplicateElements3() {
        let sut = SortedArray(unsorted: String(repeating: "A", count: 10))
        let index = sut.lastIndex(where: { $0 <= "A" })
        XCTAssertEqual(index, 9)
    }

    func testsContains() {
        let sut = SortedArray(unsorted: "Lorem ipsum")
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

    func testRemoveCountableSubrange() {
        var sut = SortedArray(unsorted: ["a","d","c","b"])
        let countableRange: CountableRange<Int> = 2..<4
        sut.removeSubrange(countableRange)
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
    
    func testSubscriptGetter() {
        let sut = SortedArray(sorted: [1, 2, 3, 5, 7, 13])
        let correct = sut[0] == 1
            && sut[1] == 2
            && sut[2] == 3
            && sut[3] == 5
            && sut[4] == 7
            && sut[5] == 13
        XCTAssert(correct)
    }
    
    func testModifySubscriptPreserveOrder() {
        var sur = SortedArray(sorted: [1, 3, 5, 7, 13])
        sur[3] += 18
        sur[4] -= 5
        sur[1] += 4
        XCTAssert(sur.isSorted())
    }
    
    func testInitLiteral() {
        let sut1: SortedArray<Int> = [1, 2, 5, 6]
        assertElementsEqual(sut1, [1, 2, 5, 6])
    }

    func testIsEquatableInSwift4_1AndHigher() {
        #if swift(>=4.1)
            let array1 = SortedArray(unsorted: [3,2,1])
            let array2 = SortedArray(unsorted: 1...3)
            XCTAssertEqual(array1, array2)
        #endif
    }

    func testComparatorFunctionIsNotRelevantForEquatable() {
        #if swift(>=4.1)
            let array1 = SortedArray(unsorted: [1,1,1], areInIncreasingOrder: <)
            let array2 = SortedArray(unsorted: [1,1,1], areInIncreasingOrder: >)
            let array3 = SortedArray(unsorted: [3,2,1,4])
            XCTAssertEqual(array1, array2)
            XCTAssertNotEqual(array1, array3)
        #endif
    }

    func testImplementsEqual() {
        let sut = SortedArray(unsorted: [3,2,1])
        XCTAssertTrue(sut == SortedArray(unsorted: 1...3))
    }

    func testImplementsNotEqual() {
        let sut = SortedArray(unsorted: 1...3)
        XCTAssertTrue(sut != SortedArray(unsorted: 1...4))
    }

    func testIsHashableInSwift4_2AndHigher() {
        #if swift(>=4.1.50)
            let array1 = SortedArray(unsorted: [3,2,1])
            let array2 = SortedArray(unsorted: 1...3)
            let array3 = SortedArray(unsorted: [3,2,1,4])
            XCTAssertEqual(array1.hashValue, array2.hashValue)
            XCTAssertNotEqual(array1.hashValue, array3.hashValue)
        #endif
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
            ("testSortedArrayWithKeyPath", testSortedArrayWithKeyPath),
            ("testSortedArrayWithKeyPathSorted", testSortedArrayWithKeyPathSorted),
            ("testSortedArrayWithKeyPathUnsorted", testSortedArrayWithKeyPathUnsorted),
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
            ("testIndexOfReturnsNilForEmptyArray", testIndexOfReturnsNilForEmptyArray),
            ("testIndexOfCanDealWithSingleElementArray", testIndexOfCanDealWithSingleElementArray),
            ("testIndexOfFindsFirstIndexOfDuplicateElements1", testIndexOfFindsFirstIndexOfDuplicateElements1),
            ("testIndexOfFindsFirstIndexOfDuplicateElements2", testIndexOfFindsFirstIndexOfDuplicateElements2),
            ("testIndexOfFindsFirstIndexOfDuplicateElements3", testIndexOfFindsFirstIndexOfDuplicateElements3),
            ("testIndexOfFindsFirstIndexOfDuplicateElements4", testIndexOfFindsFirstIndexOfDuplicateElements4),
            ("testIndexOfFindsFirstIndexOfDuplicateElements5", testIndexOfFindsFirstIndexOfDuplicateElements4),
            ("testIndexOfExistsAndIsAnAliasForFirstIndexOf", testIndexOfExistsAndIsAnAliasForFirstIndexOf),
            ("testFirstIndexWhereFindsElementInMiddle", testFirstIndexWhereFindsElementInMiddle),
            ("testFirstIndexWhereFindsFirstElement", testFirstIndexWhereFindsFirstElement),
            ("testFirstIndexWhereFindsLastElement", testFirstIndexWhereFindsLastElement),
            ("testFirstIndexWhereReturnsNilWhenNotFound", testFirstIndexWhereReturnsNilWhenNotFound),
            ("testFirstIndexWhereReturnsNilForEmptyArray", testFirstIndexWhereReturnsNilForEmptyArray),
            ("testFirstIndexWhereCanDealWithSingleElementArray", testFirstIndexWhereCanDealWithSingleElementArray),
            ("testFirstIndexWhereFindsFirstIndexOfDuplicateElements1", testFirstIndexWhereFindsFirstIndexOfDuplicateElements1),
            ("testFirstIndexWhereFindsFirstIndexOfDuplicateElements2", testFirstIndexWhereFindsFirstIndexOfDuplicateElements2),
            ("testFirstIndexWhereFindsFirstIndexOfDuplicateElements3", testFirstIndexWhereFindsFirstIndexOfDuplicateElements3),
            ("testFirstIndexWhereFindsFirstIndexOfDuplicateElements4", testFirstIndexWhereFindsFirstIndexOfDuplicateElements4),
            ("testFirstIndexWhereFindsFirstIndexOfDuplicateElements5", testFirstIndexWhereFindsFirstIndexOfDuplicateElements5),
            ("testLastIndexOfFindsElementInMiddle", testLastIndexOfFindsElementInMiddle),
            ("testLastIndexOfFindsFirstElement", testLastIndexOfFindsFirstElement),
            ("testLastIndexOfFindsLastElement", testLastIndexOfFindsLastElement),
            ("testLastIndexOfReturnsNilWhenNotFound", testLastIndexOfReturnsNilWhenNotFound),
            ("testLastIndexOfReturnsNilForEmptyArray", testLastIndexOfReturnsNilForEmptyArray),
            ("testLastIndexOfCanDealWithSingleElementArray", testLastIndexOfCanDealWithSingleElementArray),
            ("testLastIndexOfFindsLastIndexOfDuplicateElements1", testLastIndexOfFindsLastIndexOfDuplicateElements1),
            ("testLastIndexOfFindsLastIndexOfDuplicateElements2", testLastIndexOfFindsLastIndexOfDuplicateElements2),
            ("testLastIndexOfFindsLastIndexOfDuplicateElements3", testLastIndexOfFindsLastIndexOfDuplicateElements3),
            ("testLastIndexWhereFindsElementInMiddle", testLastIndexWhereFindsElementInMiddle),
            ("testLastIndexWhereFindsFirstElement", testLastIndexWhereFindsFirstElement),
            ("testLastIndexWhereFindsLastElement", testLastIndexWhereFindsLastElement),
            ("testLastIndexWhereReturnsNilWhenNotFound", testLastIndexWhereReturnsNilWhenNotFound),
            ("testLastIndexWhereReturnsNilForEmptyArray", testLastIndexWhereReturnsNilForEmptyArray),
            ("testLastIndexWhereCanDealWithSingleElementArray", testLastIndexWhereCanDealWithSingleElementArray),
            ("testLastIndexWhereFindsLastIndexOfDuplicateElements1", testLastIndexWhereFindsLastIndexOfDuplicateElements1),
            ("testLastIndexWhereFindsLastIndexOfDuplicateElements2", testLastIndexWhereFindsLastIndexOfDuplicateElements2),
            ("testLastIndexWhereFindsLastIndexOfDuplicateElements3", testLastIndexWhereFindsLastIndexOfDuplicateElements3),
            ("testsContains", testsContains),
            ("testMin", testMin),
            ("testMax", testMax),
            ("testCustomStringConvertible", testCustomStringConvertible),
            ("testCustomDebugStringConvertible", testCustomDebugStringConvertible),
            ("testFilter", testFilter),
            ("testRemoveAtIndex", testRemoveAtIndex),
            ("testRemoveSubrange", testRemoveSubrange),
            ("testRemoveCountableSubrange", testRemoveCountableSubrange),
            ("testRemoveFirst", testRemoveFirst),
            ("testRemoveFirstN", testRemoveFirstN),
            ("testRemoveLast", testRemoveLast),
            ("testRemoveLastN", testRemoveLastN),
            ("testRemoveAll", testRemoveAll),
            ("testRemoveElementAtBeginningPreservesSortOrder", testRemoveElementAtBeginningPreservesSortOrder),
            ("testRemoveElementInMiddlePreservesSortOrder", testRemoveElementInMiddlePreservesSortOrder),
            ("testRemoveElementAtEndPreservesSortOrder", testRemoveElementAtEndPreservesSortOrder),
            ("testIsEquatableInSwift4_1AndHigher", testIsEquatableInSwift4_1AndHigher),
            ("testComparatorFunctionIsNotRelevantForEquatable", testComparatorFunctionIsNotRelevantForEquatable),
            ("testImplementsEqual", testImplementsEqual),
            ("testImplementsNotEqual", testImplementsNotEqual),
            ("testIsHashableInSwift4_2AndHigher", testIsHashableInSwift4_2AndHigher),
            ("testSubscriptGetter", testSubscriptGetter),
            ("testModifySubscriptPreserveOrder", testModifySubscriptPreserveOrder),
            ("testInitLiteral", testInitLiteral),
        ]
    }
}
