//
//  Copyright © 2020 An Tran. All rights reserved.
//

import UIKit
import Foundation

struct App: Identifiable, Decodable, Equatable, Hashable {
    let version: Int
    let id: String
    var icon: UIImage?
    let name: String
    let shortDescription: String
    let description: String
    let links: [Link]
    let previews: [Preview]?
    let releaseNotes: [ReleaseNote]
    let createdAt: Date
    let updatedAt: Date

    private enum CodingKeys: String, CodingKey {
        case version, id, name, shortDescription, description, links, previews, releaseNotes, createdAt, updatedAt
    }
    
    var iconOrDefaultImage: UIImage {
        icon ?? UIImage(named: "icon")!
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(Int.self, forKey: .version)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        shortDescription = try container.decode(String.self, forKey: .shortDescription)
        description = try container.decode(String.self, forKey: .description)
        links = try container.decode([Link].self, forKey: .links)
        previews = try container.decodeIfPresent([Preview].self, forKey: .previews)
        releaseNotes = try container.decode([ReleaseNote].self, forKey: .releaseNotes)
        
        let dateTransformer = DateDecodableTransformer()
        if version >= 2 {
            createdAt = try container.decode(.createdAt, transformer: dateTransformer)
            updatedAt = try container.decode(.updatedAt, transformer: dateTransformer)
        } else {
            createdAt = Date.from(yyyyMMdd: "2020-06-06") ?? Date()
            updatedAt = Date.from(yyyyMMdd: "2020-06-06") ?? Date()
        }
    }
    
    init(
        version: Int,
        id: String,
        icon: UIImage? = nil,
        name: String,
        shortDescription: String,
        description: String,
        links: [Link],
        previews: [Preview]? = nil,
        releaseNotes: [ReleaseNote],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.version = version
        self.id = id
        self.icon = icon
        self.name = name
        self.shortDescription = shortDescription
        self.description = description
        self.links = links
        self.previews = previews
        self.releaseNotes = releaseNotes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

struct ReleaseNote: Identifiable, Decodable, Equatable, Hashable {
    var version: String
    var note: String
    
    var id: String {
        version
    }
}

struct Link: Identifiable, Equatable, Hashable {
    
    enum LinkType: String {
        case homepage
        case testflight
        case appstore
        case sourcecode
    }
    
    var value: String
    var type: LinkType
    
    var id: String {
        type.rawValue
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
        let value = try container.decode(String.self, forKey: .value)
        
        switch rawType {
            case "homepage":
                self = Link(value: value, type: .homepage)
            case "testflight":
                self = Link(value: value, type: .testflight)
            case "appstore":
                self = Link(value: value, type: .appstore)
            case "sourcecode":
                self = Link(value: value, type: .sourcecode)
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
    case invalidDate
}
