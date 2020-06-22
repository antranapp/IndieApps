//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Foundation
import XCTest

class AppStoreScreenshotTests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    func test01Categories() {
        sleep(3)
        snapshot("01Categories")
    }

    func test02AppDetail() {
        let tablesQuery = app.tables
        app.swipeUp()
        app.swipeUp()

        tablesQuery.buttons["Reference\n2"].tap()
        tablesQuery.cells.otherElements.containing(.staticText, identifier: "Indie Apps Showcases").children(matching: .image).element.tap()

        snapshot("02AppDetail")
    }
}
