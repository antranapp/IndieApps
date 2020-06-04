//
//  Copyright © 2020 An Tran. All rights reserved.
//

import SwiftUI

struct AppRootView: View {
    
    @EnvironmentObject var store: AppStore

    var body: some View {
        if store.state.isDataAvailable {
            return CategoryListContainerView().environmentObject(store).toAnyView
        } else {
            return OnboardingContainerView().environmentObject(store).toAnyView
        }
    }
}

struct OnboardingContainerView: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        Text("Onboarding")
            .onAppear(perform: startOnboarding)
    }
    
    private func startOnboarding() {
        store.send(.startOnboarding)
    }
}
