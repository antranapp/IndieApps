//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct OnboardingContainerView: View {
    
    let store: MainStore
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            return OnboardingView(viewStore: viewStore)
        }
    }
}

struct OnboardingView: View {

    let viewStore: ViewStore<MainState, MainAction>

    @State private var direction: Bool = true

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

#if DEBUG
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: .init(), reducer: appReducer, environment: AppEnvironment())
        return OnboardingContainerView(store: store)
    }
}
#endif
