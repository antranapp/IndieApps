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
                self.store.send(.hideSnackbar)
            }
        )
        
        return OnboardingView()
            .snackbar(data: snackbarDataBinding, show: snackbarShowingBinding)
            .onAppear(perform: startOnboarding)
    }
    
    private func startOnboarding() {
        store.send(.startOnboarding)
    }
}



struct OnboardingView: View {
    
    @State private var direction: Bool = true

    var body: some View {
        Image("icon")
            .frame(width: 60, height: 60)
            .scaleEffect(direction ? 1 : 2)
            .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true))
            .onAppear {
                self.direction.toggle()
            }
    }
}
