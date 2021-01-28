import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(WMATAUITests.allTests),
        testCase(UIFontExtensionTests.allTests)
    ]
}
#endif
