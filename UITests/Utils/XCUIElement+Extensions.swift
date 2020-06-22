//
//  Copyright © 2020 An Tran. All rights reserved.
//

import XCTest

extension XCUIElement {

    // Note: Exists doesn't guarantee that the element is visible in the viewport.
    var displayed: Bool {
        guard exists, !frame.isEmpty else { return false }
        return exists && XCUIApplication().windows.element(boundBy: 0).frame.contains(frame)
    }

    func scrollTo(element: XCUIElement) {
        var counter = 0
        while !element.displayed && counter < 10 {
            swipeUp()
            usleep(200_000) // wait for 200ms to finish scrolling animation
            counter += 1
        }
    }
}
