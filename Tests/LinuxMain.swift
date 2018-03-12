import XCTest
@testable import SortedArrayTests

XCTMain([
     testCase(SortedArrayTests.allTests),
     testCase(PropertyBasedTests.allTests),
     testCase(PerformanceTests.allTests),
])
