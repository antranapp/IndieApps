//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct AppListContainerView: View {
    
    let store: AppStore

    var category: Category
    
    @State var selectedApp: App?
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                ForEach(viewStore.appList) { app in
                    AppView(app: app)
                        .padding(.vertical, 8)
                        .sheet(item: self.$selectedApp) { app in
                            AppDetailView(app: app)
                    }
                    .onTapGesture {
                        self.selectedApp = app
                    }
                }
            }
            .navigationBarTitle(self.category.name)
            .onAppear {
                viewStore.send(.fetchAppList(self.category))
            }
        }
    }
}

#if DEBUG
struct AppListView_Previews: PreviewProvider {
    static var previews: some View {
        let world = AppEnvironment(
            onboardingService: MockOnboardingService(),
            gitService: nil,
            contentService: MockContentSevice())
        let category = MockContentSevice.categoryList[0]

        let store = Store(initialState: .init(), reducer: appReducer, environment: world)

        
        return AppListContainerView(store: store, category: category)
    }
}
#endif
