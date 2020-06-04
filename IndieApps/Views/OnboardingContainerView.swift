//
//  Copyright © 2020 An Tran. All rights reserved.
//

import SwiftUI

struct OnboardingContainerView: View {
    
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        
        let snackbarDataBinding = Binding<SnackbarModifier.SnackbarData>(
            get: { () -> SnackbarModifier.SnackbarData in
                return self.store.state.snackbarData
            },
            set:  { _ in }
        )
        
        let snackbarShowingBinding = Binding<Bool>(
            get: { () -> Bool in
                return self.store.state.showSnackbar
            },
            set:  { _ in
                self.store.send(.hideError)
            }
        )
        
        return Text("Onboarding")
            .snackbar(data: snackbarDataBinding, show: snackbarShowingBinding)
            .onAppear(perform: startOnboarding)
    }
    
    private func startOnboarding() {
        store.send(.startOnboarding)
    }
}

