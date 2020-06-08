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
        let apps = [
            App(
                version: 1,
                id: UUID().uuidString,
                name: "Twitter",
                shortDescription: "Twitter is cool",
                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.",
                links: [
                    .homepage("https://antran.app")
                ],
                releaseNotes: [
                    ReleaseNote(version: "1.0.0 (1)", note: "Fix a lot of bugs"),
                    ReleaseNote(version: "1.0.0 (2)", note: "Fix a lot of bugs"),
                ]
            ),
        ]
        
        let category = Category(
            name: "Productivity",
            numberOfApps: 1
        )
        let store = Store(initialState: .init(), reducer: appReducer, environment: World())
        
        return AppListContainerView(store: store, category: category)
    }
}
#endif
