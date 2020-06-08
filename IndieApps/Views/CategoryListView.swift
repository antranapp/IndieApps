//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import Combine

struct CategoryListContainerView: View {
    
    let store: MainStore
        
    var body: some View {
        NavigationView {
            WithViewStore(self.store) { viewStore in
                List {
                    ForEach(viewStore.categoryList) { category in
                        NavigationLink(
                            destination: IfLetStore(
                                self.store.scope(state: { $0.selection }, action: MainAction.category),
                                then: { AppListContainerView(store: $0, selectedApp: nil) },
                                else: ActivityIndicator()),
                            tag: category,
                            selection: viewStore.binding(
                                get: { $0.selection?.category },
                                send: { MainAction.setNavigation(selection: $0) }
                            )) {
                            CategoryView(category: category)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .navigationBarTitle("Categories")
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarItems(leading:
                    NavigationLink(destination: SettingsView(store: self.store), label: {
                        Image(systemName: "gear")
                    })
                )
                .onAppear {
                    viewStore.send(.fetchCategories)
                }
            }
        }
    }
}


#if DEBUG
struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        let world = AppEnvironment(
            onboardingService: MockOnboardingService(),
            gitService: nil,
            contentService: MockContentSevice())
        let store = Store(initialState: .init(), reducer: appReducer, environment: world)
        return CategoryListContainerView(store: store)
    }
}
#endif