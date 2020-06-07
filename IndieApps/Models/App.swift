//
//  Copyright © 2020 An Tran. All rights reserved.
//

import UIKit
import Foundation

struct App: Identifiable, Decodable {
    var id: String
    var icon: UIImage? = nil
    var name: String
    var shortDescription: String
    var description: String
    var links: [Link]
    var releaseNotes: [ReleaseNote]

    private enum CodingKeys: String, CodingKey {
        case id, name, shortDescription, description, links, releaseNotes
    }
}

struct ReleaseNote: Identifiable, Decodable {
    var version: String
    var note: String
    
    var id: String {
        version
    }
}

enum Link: Identifiable {
    case homepage(_ www: String)
    case testflight(_ www: String)
    case appstore(_ www: String)

    var type: String {
        switch self {
            case .homepage:
                return "homepage"
            case .testflight:
                return "testflight"
            case .appstore:
                return "appstore"
        }
    }
    
    var value: String {
        switch self {
            case .homepage(let value):
                return value
            case .testflight(let value):
                return value
            case .appstore(let value):
                return value
        }
    }
    
    var id: String {
        type
    }
}

extension Link: Decodable {
    
    enum Key: String, CodingKey {
        case type
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawType = try container.decode(String.self, forKey: .type)
        let rawValue = try container.decode(String.self, forKey: .value)
        
        switch rawType {
            case "homepage":
                self = .homepage(rawValue)
            case "testflight":
                self = .testflight(rawValue)
            case "appstore":
                self = .appstore(rawValue)
            default:
                throw DecodingError.unknownType
        }
    }
}

enum DecodingError: Error {
    case unknownType
}
