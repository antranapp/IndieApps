//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import Combine

struct CategoryListContainerView: View {
    
    let store: AppStore
    
    var body: some View {
        NavigationView {
            WithViewStore(self.store) { viewStore in
                List {
                    ForEach(viewStore.categoryList) { category in
                        NavigationLink(destination: AppListContainerView(store: self.store, category: category)) {
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
                    viewStore.send(.fetchCategoryList)
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
