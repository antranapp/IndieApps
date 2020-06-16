//
//  RegexCodableTransformer.swift
//  CodableExtensions
//
//  Created by James Ruston on 11/10/2017.
//

import Foundation

class RegexCodableTransformer: CodingContainerTransformer {
    
    typealias Input = String
    typealias Output = NSRegularExpression
    
    init() {}
    
    func transform(_ decoded: Input) throws -> Output {
        return try NSRegularExpression(pattern: decoded, options: [])
    }
    
    func transform(_ encoded: NSRegularExpression) throws -> String {
        return encoded.pattern
    }
    
}
