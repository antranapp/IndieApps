//
//  Copyright © 2020 An Tran. All rights reserved.
//

@testable import IndieApps
import XCTest

class SettingsManagerTests: XCTestCase {

    override class func setUp() {
        super.setUp()

        UserDefaults.standard.set(nil, forKey: Key.remoteRepositoryURL.rawValue)
        UserDefaults.standard.set(nil, forKey: Key.branch.rawValue)
    }

    func testDefaultConfiguration() {
        let settingsManager = SettingsManager()
        XCTAssertEqual(settingsManager.configuration, Configuration())
    }

    func testUpdateRemoteRepositoryURL() {
        let settingsManager = SettingsManager()
        let expectedRemoreRepositoryURL = URL(string: "https://test.com")
        settingsManager.update(remoteRepositoryURLString: "https://test.com")
        XCTAssertEqual(settingsManager.configuration.contentLocation.remoteURL, expectedRemoreRepositoryURL)
    }

    func testUpdateBranch() {
        let settingsManager = SettingsManager()
        let expectedBranch = "testBranch"
        settingsManager.update(branch: expectedBranch)
        XCTAssertEqual(settingsManager.configuration.contentLocation.branch, expectedBranch)
    }
}
