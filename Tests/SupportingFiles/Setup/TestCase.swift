//
//  Copyright © 2020 An Tran. All rights reserved.
//

@testable import IndieApps
import XCTest

class TestCase: XCTestCase {
    
    struct TimeOut {
        static let long: TimeInterval = 10
        static let short: TimeInterval = 0.5
    }
    
    override func setUp() {
        super.setUp()
        
        resetContent()
    }
    
    func resetContent() {
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: Configuration.Default.rootFolderURL)
    }
    
}
