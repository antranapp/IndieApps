//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture

enum MainAction {
    case startOnboarding
    case endOnboarding
    case cloneContent
    case updateContent
    case resetContent
    case setContentState(ContentState, Error?)
    case fetchCategories
    case setCategories([Category])
    case showError(Error)
    case showMessage(title: String?, message: String, type: SnackbarModifier.SnackbarType)
    case hideSnackbar
    case goToOnboarding
    case switchContent(Configuration)
    
    // For navigation to Category component
    case category(CategoryAction)
    case setNavigation(selection: Category?)
}

extension MainAction: Equatable {
    static func == (lhs: MainAction, rhs: MainAction) -> Bool {
        switch (lhs, rhs) {
            case (.startOnboarding, .startOnboarding):
                return true
            case (.endOnboarding, .endOnboarding):
                return true
            case (.updateContent, .updateContent):
                return true
            case (.resetContent, .resetContent):
                return true
            case (.setContentState(let lState, let lError), .setContentState(let rState, let rError)):
                return lState == rState &&
                    lError?._code == rError?._code
            case (.fetchCategories, .fetchCategories):
                return true
            case (.setCategories(let lCategories), .setCategories(let rCategories)):
                return lCategories == rCategories
            case (.showError(let lError), .showError(let rError)):
                return lError._code == rError._code
            case (.showMessage(let lTitle, let lMessage, let lType), .showMessage(let rTitle, let rMessage, let rType)):
                return lTitle == rTitle &&
                    lMessage == rMessage &&
                    lType == rType
            case (.hideSnackbar, .hideSnackbar):
                return true
            case (.goToOnboarding, .goToOnboarding):
                return true
            case (.category(let lCategoryAction), .category(let rCategoryAction)):
                return lCategoryAction == rCategoryAction
            case (.setNavigation(let lCategory), .setNavigation(let rCategory)):
                return lCategory == rCategory
            default:
                return false
        }
    }
}
