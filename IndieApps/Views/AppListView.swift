//
//  Copyright © 2020 An Tran. All rights reserved.
//

import SwiftUI

struct AppListContainerView: View {
    
    @EnvironmentObject var store: AppStore

    var category: Category
    
    var body: some View {
        AppListView(appList: store.state.appList)
            .navigationBarTitle(category.name)
            .onAppear(perform: fetchAppList)
    }
    
    private func fetchAppList() {
        store.send(.fetchAppList(category))
    }
}


struct AppListView: View {

    @State var selectedApp: App? = nil
    
    let appList: [App]
    
    var body: some View {
        List {
            ForEach(appList) { app in
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
    }
}


#if DEBUG
struct AppListView_Previews: PreviewProvider {
    static var previews: some View {        
        let apps = [
            App(
                id: UUID().uuidString,
                name: "Twitter",
                shortDescription: "Twitter is cool",
                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.",
                releaseNotes: [
                    ReleaseNote(id: UUID().uuidString, version: "1.0.0 (1)", note: "Fix a lot of bugs"),
                    ReleaseNote(id: UUID().uuidString, version: "1.0.0 (2)", note: "Fix a lot of bugs"),
                ]
            ),
            App(
                id: UUID().uuidString,
                name: "Twitter",
                shortDescription: "Twitter is cool",
                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.",
                releaseNotes: [
                    ReleaseNote(id: UUID().uuidString, version: "1.0.0 (1)", note: "Fix a lot of bugs"),
                    ReleaseNote(id: UUID().uuidString, version: "1.0.0 (2)", note: "Fix a lot of bugs"),
                ]
            ),
            App(
                id: UUID().uuidString,
                name: "Twitter",
                shortDescription: "Twitter is cool",
                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.",
                releaseNotes: [
                    ReleaseNote(id: UUID().uuidString, version: "1.0.0 (1)", note: "Fix a lot of bugs"),
                    ReleaseNote(id: UUID().uuidString, version: "1.0.0 (2)", note: "Fix a lot of bugs"),
                ]
            ),
            App(
                id: UUID().uuidString,
                name: "Twitter",
                shortDescription: "Twitter is cool",
                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.",
                releaseNotes: [
                    ReleaseNote(id: UUID().uuidString, version: "1.0.0 (1)", note: "Fix a lot of bugs"),
                    ReleaseNote(id: UUID().uuidString, version: "1.0.0 (2)", note: "Fix a lot of bugs"),
                ]
            ),
            App(
                id: UUID().uuidString,
                name: "Twitter",
                shortDescription: "Twitter is cool",
                description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.",
                releaseNotes: [
                    ReleaseNote(id: UUID().uuidString, version: "1.0.0 (1)", note: "Fix a lot of bugs"),
                    ReleaseNote(id: UUID().uuidString, version: "1.0.0 (2)", note: "Fix a lot of bugs"),
                ]
            ),
        ]
        
        
        return AppListView(appList: apps)
    }
}
#endif
