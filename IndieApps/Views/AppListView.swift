//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct AppListContainerView: View {
    
    let store: CategoryStore

    @State var selectedApp: App?
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                ForEach(viewStore.apps) { app in
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
            .navigationBarTitle(viewStore.category.name)
            .onAppear {
                viewStore.send(.fetchApps)
            }
        }
    }
}

#if DEBUG
struct AppListView_Previews: PreviewProvider {
    static var previews: some View {
        let categoryEnvironment = CategoryEnvironment(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            contentService: MockContentSevice()
        )
        let category = MockContentSevice.categoryList[0]

        let store = Store(initialState: CategoryState(category: category), reducer: categoryReducer, environment: categoryEnvironment)
        
        return AppListContainerView(store: store)
    }
}
#endif
