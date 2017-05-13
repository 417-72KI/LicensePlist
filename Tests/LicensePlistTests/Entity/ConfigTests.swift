import Foundation
import XCTest
@testable import LicensePlistCore

class ConfigTests: XCTestCase {

    func testInit_empty_yaml() {
        XCTAssertEqual(Config(yaml: ""), Config(githubs: [], excludes: [], renames: [:]))
    }
    func testInit_sample() {
        let path = "https://raw.githubusercontent.com/mono0926/LicensePlist/master/Tests/LicensePlistTests/Resources/license_plist.yml"
        XCTAssertEqual(Config(yaml: URL(string: path)!.lp.download().resultSync().value!),
                       Config(githubs: [GitHub(name: "LicensePlist", nameSpecified: "License Plist", owner: "mono0926", version: "1.2.0"),
                                        GitHub(name: "NativePopup", nameSpecified: nil, owner: "mono0926", version: nil)],
                              excludes: ["RxSwift", "ios-license-generator", "/^Core.*$/"],
                              renames: ["LicensePlist": "License Plist"]))
    }

    func testExcluded() {
        let target = Config(githubs: [], excludes: ["lib1"], renames: [:])
        XCTAssertTrue(target.excluded(name: "lib1"))
        XCTAssertFalse(target.excluded(name: "lib2"))
    }

    func testExtractRegex() {
        XCTAssertEqual(Config.extractRegex("/^Core.*$/"), "^Core.*$")
        XCTAssertNil(Config.extractRegex("/^Core.*$/a"))
    }

    func testExcluded_regex() {
        let target = Config(githubs: [], excludes: ["/^lib.*$/"], renames: [:])
        XCTAssertTrue(target.excluded(name: "lib1"))
        XCTAssertTrue(target.excluded(name: "lib2"))
        XCTAssertFalse(target.excluded(name: "hello"))
    }

    func testApply_filterExcluded() {
        let config = Config(githubs: [], excludes: ["lib2"], renames: [:])
        let shouldBeIncluded = GitHub(name: "lib1", nameSpecified: nil, owner: "o1", version: nil)
        let result = config.filterExcluded([shouldBeIncluded, GitHub(name: "lib2", nameSpecified: nil, owner: "o2", version: nil)])
        XCTAssertEqual(result, [shouldBeIncluded])
    }

    func testApply_githubs() {
        let github1 = GitHub(name: "github1", nameSpecified: nil, owner: "g1", version: nil)
        let config = Config(githubs: [github1], excludes: ["lib2"], renames: [:])
        let shouldBeIncluded = GitHub(name: "lib1", nameSpecified: nil, owner: "o1", version: nil)
        let result = config.apply(githubs: [shouldBeIncluded, GitHub(name: "lib2", nameSpecified: nil, owner: "o2", version: nil)])
        XCTAssertEqual(result, [github1, shouldBeIncluded])
    }
}
