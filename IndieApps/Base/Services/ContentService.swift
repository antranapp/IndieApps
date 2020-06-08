//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Yams
import Files
import Combine
import UIKit

protocol ContentServiceProtocol {
    func fetchCategoryList() -> AnyPublisher<[Category], Never>
    func fetchAppList(in category: Category) -> AnyPublisher<[App], Never>
}

class ContentService: ContentServiceProtocol {
    
    // MARK: - Properties
    
    lazy private var appFolder: Folder = try! rootFolder.subfolder(named: "apps")
    lazy private var dataFolder: Folder? = try? rootFolder.subfolder(named: "data")
    lazy private var rootFolder = {
       try! Folder(path: rootFolderPath)
    }()
    private var rootFolderPath: String
    
    // MARK: - Constructor
    
    init(rootFolderPath: String) {
        self.rootFolderPath = rootFolderPath
    }
        
    // MARK: - APIs
    
    func fetchCategoryList() -> AnyPublisher<[Category], Never> {
        let categories = appFolder.subfolders.compactMap {
            mapFolderToCategory($0)
        }
        return Just(categories).eraseToAnyPublisher()
    }
    
    func fetchAppList(in category: Category) -> AnyPublisher<[App], Never> {
        do {
            let categoryFolder = try mapCategoryToFolder(category)
            let apps = try categoryFolder.subfolders.compactMap {
                try mapFolderToApp($0)
            }
            return Just(apps).eraseToAnyPublisher()
        } catch {
            return Just([]).eraseToAnyPublisher()
        }
    }
    
    // MARK: - Private helpers
    
    private func mapCategoryToFolder(_ category: Category) throws -> Folder {
        return try appFolder.subfolder(named: category.name)
    }
    
    private func mapFolderToCategory(_ folder: Folder) -> Category {
        return Category(name: folder.name, numberOfApps: folder.subfolders.count())
    }
    
    private func mapFolderToApp(_ folder: Folder) throws -> App {
        let appFile = try folder.file(named: "app.yml")
        let content = try appFile.readAsString()
        let decoder = YAMLDecoder()
        var app = try decoder.decode(App.self, from: content)
        if let iconFile = try? folder.file(named: "icon.png") {
            app.icon = UIImage(contentsOfFile: iconFile.path)
        }
        return app
    }
}
