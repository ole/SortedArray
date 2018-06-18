import XCTest
@testable import UnitTests
@testable import PerformanceTests

XCTMain([
     testCase(SortedArrayTests.allTests),
     testCase(PerformanceTests.allTests),
])
