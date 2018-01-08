import XCTest
@testable import SortedArrayTests

XCTMain([
     testCase(SortedArrayTests.allTests),
     testCase(PerformanceTests.allTests),
])
