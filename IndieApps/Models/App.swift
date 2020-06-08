//
//  Copyright © 2020 An Tran. All rights reserved.
//

import UIKit
import Foundation

struct App: Identifiable, Decodable, Equatable {
    var version: Int
    var id: String
    var icon: UIImage?
    var name: String
    var shortDescription: String
    var description: String
    var links: [Link]
    var previews: [Preview]?
    var releaseNotes: [ReleaseNote]

    private enum CodingKeys: String, CodingKey {
        case version, id, name, shortDescription, description, links, previews, releaseNotes
    }
    
    var iconOrDefaultImage: UIImage {
        icon ?? UIImage(named: "icon")!
    }
}

struct ReleaseNote: Identifiable, Decodable, Equatable {
    var version: String
    var note: String
    
    var id: String {
        version
    }
}

enum Link: Identifiable, Equatable {
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

enum Preview: Identifiable, Equatable {
    case web(_ links: [String])
    case macOS(_ links: [String])
    case iOS(_ links: [String])
    case iPadOS(_ links: [String])
    case watchOS(_ links: [String])
    case tvOS(_ links: [String])
    
    var id: String {
        type
    }
    
    var type: String {
        switch self {
            case .web:
                return "web"
            case .macOS:
                return "macOS"
            case .iOS:
                return "iOS"
            case .iPadOS:
                return "iPadOS"
            case .watchOS:
                return "watchOS"
            case .tvOS:
                return "tvOS"
        }
    }
}

extension Preview: Decodable {
    
    enum Key: String, CodingKey {
        case type
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawType = try container.decode(String.self, forKey: .type)
        let rawValue = try container.decode([String].self, forKey: .value)
        
        switch rawType {
            case "web":
                self = .web(rawValue)
            case "macOS":
                self = .macOS(rawValue)
            case "iOS":
                self = .iOS(rawValue)
            case "iPadOS":
                self = .iPadOS(rawValue)
            case "watchOS":
                self = .watchOS(rawValue)
            case "tvOS":
                self = .tvOS(rawValue)
            default:
                throw DecodingError.unknownType
        }
    }
}

enum DecodingError: Error {
    case unknownType
}
