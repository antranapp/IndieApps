//
//  DecodingContainerTransformer.swift
//  CodeableExtensions
//
//  Created by James Ruston on 11/10/2017.
//

import Foundation

protocol DecodingContainerTransformer {
    
    associatedtype Input
    associatedtype Output
    func transform(_ decoded: Input) throws -> Output
    
}

protocol EncodingContainerTransformer {
    
    associatedtype Input
    associatedtype Output
    func transform(_ encoded: Output) throws -> Input
    
}

typealias CodingContainerTransformer = DecodingContainerTransformer & EncodingContainerTransformer
