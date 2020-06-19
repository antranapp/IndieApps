//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import Combine

struct CategoryListContainerView: View {
    
    let store: MainStore
        
    var body: some View {
        GeometryReader{ geo in
            if (UIDevice.current.userInterfaceIdiom == .pad){
                NavigationView{
                    self.makeContent()
                }.navigationViewStyle(DoubleColumnNavigationViewStyle())
                    .padding(.leading, geo.size.width < geo.size.height ? 0.25 : 0)
            }else{
                NavigationView{
                    self.makeContent()
                }.navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
    
    private func makeContent() -> some View {
        WithViewStore(self.store) { viewStore in
            List {
                viewStore.categories.map {
                    ForEach($0) { category in
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
            }
            .navigationBarTitle("Categories")
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarItems(leading:
                NavigationLink(
                    destination: SettingsView(
                        store: self.store
                    ),
                    label: {
                        Image(systemName: "gear")
                }
                )
            )
                .onAppear {
                    viewStore.send(.fetchCategories)
            }
            .snackbar(
                data: viewStore.binding(
                    get: { $0.snackbarData },
                    send: { _ in MainAction.hideSnackbar }
                )
            )
        }
    }
}


#if DEBUG
struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        let world = MainEnvironment(
            configurationProvider: { Configuration() },
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
        )
        let store = Store(initialState: .init(), reducer: mainReducer, environment: world)
        return CategoryListContainerView(store: store)
    }
}
#endif
