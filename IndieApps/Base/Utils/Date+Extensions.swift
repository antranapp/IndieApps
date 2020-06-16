//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Foundation

extension Date {
    
    static func from(yyyyMMdd dateString: String) -> Date? {
        let formatter = DateFormatter.yyyyMMdd
        return formatter.date(from: dateString)
    }
    
}
