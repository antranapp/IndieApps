//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Foundation

extension String {
    
    func combinePath(_ component: String) -> String {
        return NSString(string: self).appendingPathComponent(component)
    }

    var djb2hash: Int {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
    
    var sdbmhash: Int {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(0) {
            (Int($1) &+ ($0 << 6) &+ ($0 << 16)).addingReportingOverflow(-$0).partialValue
        }
    }
    
    var asValidPath: String {
        var invalidCharacters = CharacterSet(charactersIn: ":/.")
        invalidCharacters.formUnion(.newlines)
        invalidCharacters.formUnion(.illegalCharacters)
        invalidCharacters.formUnion(.controlCharacters)
        
        let newString = self
            .components(separatedBy: invalidCharacters)
            .joined(separator: "_")
        
        return newString
    }
}
