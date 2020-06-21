//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import Foundation

enum MainAction {
    case startOnboarding
    case endOnboarding
    case cloneContent
    case updateContent
    case resetContent
    case setContentState(ContentState)
    case fetchCategories
    case setCategories([Category])
    case showError(Error)
    case showMessage(title: String?, message: String, type: SnackbarModifier.SnackbarType)
    case hideSnackbar
    case goToOnboarding
    case switchContent(URL, String)

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
        case let (.setContentState(lState), .setContentState(rState)):
            return lState == rState
        case (.fetchCategories, .fetchCategories):
            return true
        case let (.setCategories(lCategories), .setCategories(rCategories)):
            return lCategories == rCategories
        case let (.showError(lError), .showError(rError)):
            return lError._code == rError._code
        case let (.showMessage(lTitle, lMessage, lType), .showMessage(rTitle, rMessage, rType)):
            return lTitle == rTitle &&
                lMessage == rMessage &&
                lType == rType
        case (.hideSnackbar, .hideSnackbar):
            return true
        case (.goToOnboarding, .goToOnboarding):
            return true
        case let (.category(lCategoryAction), .category(rCategoryAction)):
            return lCategoryAction == rCategoryAction
        case let (.setNavigation(lCategory), .setNavigation(rCategory)):
            return lCategory == rCategory
        default:
            return false
        }
    }
}
