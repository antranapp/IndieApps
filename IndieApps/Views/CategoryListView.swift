//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import Combine

struct CategoryListContainerView: View {
    
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
        
        return NavigationView {
            WithViewStore(self.store) { viewStore in
                CategoryListView(
                    store: self.store,
                    categoryList: viewStore.categoryList
                )
                .navigationBarTitle("Categories")
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarItems(leading:
                    NavigationLink(destination: SettingsView(store: self.store), label: {
                        Image(systemName: "gear")
                    })
                )
                //            .snackbar(data: snackbarDataBinding, show: snackbarShowingBinding)
            }
        }
        .onAppear(perform: fetchCategoryList)
    }
    
    private func fetchCategoryList() {
//        store.send(.fetchCategoryList)
    }
}

private struct CategoryListView: View {
    
    let store: AppStore
    let categoryList: [Category]
    
    var body: some View {
        
        List {
            ForEach(categoryList) { category in
                NavigationLink(destination: AppListContainerView(store: self.store, category: category)) {
                    CategoryView(category: category)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#if DEBUG
struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        let list = [
            Category(name: "Movies", numberOfApps: 1),
            Category(name: "Photography", numberOfApps: 2)
        ]
        
        let store = Store(initialState: .init(), reducer: appReducer, environment: World())
        return CategoryListContainerView(store: store)
    }
}
#endif
