import XCTest

// FIXME: Can be replaced with XCTAssertEqual when we drop Swift 4.0 compatibility
func assertElementsEqual<S1, S2>(_ expression1: @autoclosure () throws -> S1, _ expression2: @autoclosure () throws -> S2, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line)
    where S1: Sequence, S2: Sequence, S1.Element == S2.Element, S1.Element: Equatable
{
    // This should give a better error message than using XCTAssert(try expression1().elementsEqual(expression2()), ...)
    try XCTAssertEqual(Array(expression1()), Array(expression2()), message, file: file, line: line)
}
