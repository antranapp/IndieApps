//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct AppRootView: View {
    
    let store: MainStore
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            self.makeView(contentState: viewStore.contentState)
        }
    }
    
    // MARK: Private helpers
    
    private func makeView(contentState: ContentState) -> some View {
        switch contentState {
            case .available:
                return CategoryListContainerView(store: store).eraseToAnyView()
            case .unavailable:
                return ContentUnavailableView(store: store).eraseToAnyView()
            case .unknown:
                return OnboardingContainerView(store: store).eraseToAnyView()
        }
    }
}

struct ContentUnavailableView: View {
    var store: MainStore
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text("There is a problem fetching the content!. Do you want to try again?")
                    .font(.headline)
                    .padding(.bottom, 20)
                
                Button(action: {
                    viewStore.send(.goToOnboarding)
                }) {
                    Text("Retry")
                }
                
                Text("If the problem persists, please consider to reinstall the app.")
                    .font(.body)
                    .padding(.top, 20)
            }
            .padding()
        }
    }
}
