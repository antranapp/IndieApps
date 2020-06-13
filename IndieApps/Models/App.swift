//
//  Copyright © 2020 An Tran. All rights reserved.
//

import CasePaths
import UIKit
import Foundation

struct App: Identifiable, Decodable, Equatable, Hashable {
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

struct ReleaseNote: Identifiable, Decodable, Equatable, Hashable {
    var version: String
    var note: String
    
    var id: String {
        version
    }
}

enum Link: Identifiable, Equatable, Hashable {
    case homepage(String)
    case testflight(String)
    case appstore(String)

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

struct Preview: Identifiable, Equatable, Hashable {
    
    enum PreviewType: String {
        case web
        case macOS
        case iOS
        case iPadOS
        case watchOS
        case tvOS
        
        var description: String {
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
    
    let type: PreviewType
    let links: [URL]
    
    var id: String {
        type.description
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
        let urls = rawValue.compactMap { URL(string: $0) }

        guard let type = PreviewType(rawValue: rawType) else {
            throw DecodingError.unknownType
        }
        
        self = Preview(type: type, links: urls)
    }
}

enum DecodingError: Error {
    case unknownType
}
