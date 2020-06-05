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
    
    private var appFolder: Folder
    private var dataFolder: Folder?
    
    // MARK: - Constructor
    
    init(rootFolder: Folder) {
        self.appFolder = try! rootFolder.subfolder(named: "apps")
        self.dataFolder = try? rootFolder.subfolder(named: "data")
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
