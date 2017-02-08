import XCTest

func assertElementsEqual<S1, S2>(_ expression1: @autoclosure () throws -> S1, _ expression2: @autoclosure () throws -> S2, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line)
    where S1: Sequence, S2: Sequence, S1.Iterator.Element == S2.Iterator.Element, S1.Iterator.Element: Equatable {

    // This should give a better error message than using XCTAssert(try expression1().elementsEqual(expression2()), ...)
    XCTAssertEqual(Array(try expression1()), Array(try expression2()), message, file: file, line: line)
}
