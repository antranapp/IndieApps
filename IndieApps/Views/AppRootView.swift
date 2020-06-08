//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct AppRootView: View {
    
    let store: AppStore

    var body: some View {
        WithViewStore(self.store) { viewStore in
            self.makeView(isDataAvailable: viewStore.isDataAvailable)
        }
    }
    
    // MARK: Private helpers
    
    private func makeView(isDataAvailable: Bool) -> some View {
        if isDataAvailable {
            return CategoryListContainerView(store: store).eraseToAnyView()
        } else {
            return OnboardingContainerView(store: store).eraseToAnyView()
        }
    }
}
