//
//  Copyright © 2020 An Tran. All rights reserved.
//

enum ContentState: Equatable {
    case unknown
    case unavailable
    case available
}

struct MainState: Equatable {
    var snackbarData: SnackbarModifier.SnackbarData?
    var contentState: ContentState = .unknown
    var categories: [Category]?
    var selection: CategoryState?
}
