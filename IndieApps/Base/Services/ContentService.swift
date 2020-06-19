//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Yams
import Files
import Combine
import UIKit

protocol ContentServiceProtocol {
    func fetchCategoryList() -> AnyPublisher<[Category], Error>
    func fetchAppList(in category: Category) -> AnyPublisher<[App], Error>
}

class ContentService: ContentServiceProtocol {
    
    // MARK: - Properties
    
    private var appFolder: Folder {
        // TODO: dont force unwrap here
        try! rootFolder.subfolder(named: "apps")
    }
    private var dataFolder: Folder? {
        try? rootFolder.subfolder(named: "data")
    }
    private var rootFolder: Folder {
        // TODO: dont force unwrap here
        try! Folder(path: localURL.path)
    }
    
    private var contentLocationProvider: ContentLocationProvider
    
    private var localURL: URL {
        contentLocationProvider().localURL
    }
    
    // MARK: - Constructor
    
    init(contentLocationProvider: @escaping ContentLocationProvider) {
        self.contentLocationProvider = contentLocationProvider
    }
        
    // MARK: - APIs
    
    func fetchCategoryList() -> AnyPublisher<[Category], Error> {
        Future { promise in
            let categories = self.appFolder.subfolders.compactMap {
                self.mapFolderToCategory($0)
            }
            promise(.success(categories))
        }.eraseToAnyPublisher()
    }
    
    func fetchAppList(in category: Category) -> AnyPublisher<[App], Error> {
        Future { promise in
            do {
                let categoryFolder = try self.mapCategoryToFolder(category)
                let apps = try categoryFolder.subfolders.compactMap {
                    try self.mapFolderToApp($0)
                }
                promise(.success(apps))
            } catch {
                print(error)
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
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
