//
//  Copyright © 2020 An Tran. All rights reserved.
//

enum ContentState {
    case unknown
    case unavailable(Error?)
    case available
}

extension ContentState: Equatable {
    static func == (lhs: ContentState, rhs: ContentState) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown):
            return true
        case let (.unavailable(lError), .unavailable(rError)):
            return lError?._code == rError?._code &&
                lError?._domain == rError?._domain
        case (.available, .available):
            return true
        default:
            return false
        }
    }
}

struct MainState: Equatable {
    var snackbarData: SnackbarModifier.SnackbarData?
    var contentState: ContentState = .unknown
    var categories: [Category]?
    var selection: CategoryState?
}
