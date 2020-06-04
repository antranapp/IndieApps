//
//  Copyright © 2020 An Tran. All rights reserved.
//

import Files
import Combine
import Foundation

struct World {
    var onboardingService = OnboardingService()
    var contentService = ContentService(rootFolder: try! Folder(path: FileManager.default.contentPath!))
}

enum AppAction {
    case startOnboarding
    case endOnboarding
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
