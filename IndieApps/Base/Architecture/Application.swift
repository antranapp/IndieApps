//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Files
import Combine
import Foundation

class World {
    var onboardingService: OnboardingServiceProtocol = OnboardingService()
    
    // Making the following variables lazy to ensure that we have a `content` folder after Onboarding.
    lazy var gitService: GitServiceProtocol? = GitService(localRepositoryFolder: rootContentFolder, remoteRepositoryURL: URL(string: "https://github.com/antranapp/IndieAppsContent.git")!)
    lazy var contentService: ContentServiceProtocol = ContentService(rootFolder: rootContentFolder)
    lazy var rootContentFolder: Folder = try! Folder(path: FileManager.default.contentPath!)
}

indirect enum AppAction {
    case startOnboarding
    case endOnboarding
    case updateContent
    case fetchCategoryList
    case setCategoryList(_ categoryList: [Category])
    case fetchAppList(_ category: Category)
    case setAppList(_ appList: [App])
    case showError(_ error: Error)
    case hideError
}

struct AppState {
    var showSnackbar: Bool = false
    var snackbarData = SnackbarModifier.SnackbarData(title: "", detail: "", type: .info)
    var isDataAvailable: Bool = false
    var categoryList: [Category] = []
    var appList: [App] = []
}

typealias AppStore = Store<AppState, AppAction, World>

extension FileManager {
    var contentPath: String? {
        return self.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("content").path
    }
}
