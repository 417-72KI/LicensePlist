import Foundation
import XCTest
@testable import LicensePlistCore

class LicensePlistHolderTests: XCTestCase {
    func testLoad_empty() {
        let result = LicensePlistHolder.load(licenses: [], config: Config.empty)
        let (root, items) = result.deserialized()
        let rootItems = root["PreferenceSpecifiers"]!
        XCTAssertTrue(rootItems.isEmpty)
        XCTAssertTrue(items.isEmpty)
    }
    func testLoad_one() {
        let pods = CocoaPods(name: "name", nameSpecified: nil, version: nil)
        let podsLicense = CocoaPodsLicense(library: pods, body: "'<body>")
        let result = LicensePlistHolder.load(licenses: [podsLicense], config: Config.empty)
        let (root, items) = result.deserialized()
        let rootItems = root["PreferenceSpecifiers"]!
        XCTAssertEqual(rootItems.count, 1)
        XCTAssertEqual(items.count, 1)

        let rootItems1 = rootItems.first!
        XCTAssertEqual(rootItems1["Type"], "PSChildPaneSpecifier")
        XCTAssertEqual(rootItems1["Title"], "name")
        XCTAssertEqual(rootItems1["File"], "com.mono0926.LicensePlist/name")

        let item1 = items.first!.1
        let item1_1 = item1["PreferenceSpecifiers"]!.first!
        XCTAssertEqual(item1_1["Type"], "PSGroupSpecifier")
        XCTAssertEqual(item1_1["FooterText"], "\'<body>")
    }
}
