//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct OnboardingContainerView: View {
    
    let store: AppStore
    
    var body: some View {
        
//        let snackbarDataBinding = Binding<SnackbarModifier.SnackbarData>(
//            get: { () -> SnackbarModifier.SnackbarData in
//                return self.store.state.snackbarData
//            },
//            set:  { _ in }
//        )
//
//        let snackbarShowingBinding = Binding<Bool>(
//            get: { () -> Bool in
//                return self.store.state.showSnackbar
//            },
//            set:  { _ in
//                self.store.send(.hideSnackbar)
//            }
//        )
        
        return
            WithViewStore(self.store) { viewStore in
                OnboardingView(viewStore: viewStore)
                    //            .snackbar(data: snackbarDataBinding, show: snackbarShowingBinding)
            }
    }
}



struct OnboardingView: View {
    
    @State private var direction: Bool = true
    
    let viewStore: ViewStore<AppState, AppAction>

    var body: some View {
        Image("icon")
            .frame(width: 60, height: 60)
            .scaleEffect(direction ? 1 : 2)
            .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true))
            .onAppear(perform: startOnboarding)
    }
    
    private func startOnboarding() {
        viewStore.send(.startOnboarding)
        direction.toggle()
    }

}
