import Foundation
import XCTest
import APIKit
@testable import LicensePlistCore

class GitHubLicenseCollectorTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        TestUtil.setGitHubToken()
    }

    func testCollect() {
        let carthage = GitHub(name: "NativePopup", owner: "mono0926")
        let license = GitHubLicense.collect(carthage).resultSync().value!
        XCTAssertEqual(license.library, carthage)
        XCTAssertTrue(license.body.hasPrefix("MIT License"))
        XCTAssertEqual(license.githubResponse.downloadUrl,
                       URL(string: "https://raw.githubusercontent.com/mono0926/NativePopup/master/LICENSE"))
        XCTAssertEqual(license.githubResponse.kind.spdxId, "MIT")
    }

    func testCollect_forked() {
        let carthage = GitHub(name: "ios_sdk", owner: "gram30")
        let license = GitHubLicense.collect(carthage).resultSync().value!
        var forked = carthage
        forked.owner = "adjust"
        XCTAssertEqual(license.library, forked)
        XCTAssertTrue(license.body.hasPrefix("Copyright (c)"))
        XCTAssertEqual(license.githubResponse.downloadUrl,
                       URL(string: "https://raw.githubusercontent.com/adjust/ios_sdk/master/MIT-LICENSE"))
        XCTAssertEqual(license.githubResponse.kind.spdxId, "MIT")
    }
    func testCollect_invalid() {
        let carthage = GitHub(name: "abcde", owner: "invalid")
        let license = GitHubLicense.collect(carthage).result
        XCTAssertTrue(license == nil)
    }
}
