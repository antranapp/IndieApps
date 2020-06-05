//
//  Copyright © 2020 An Tran. All rights reserved.
//

import SwiftUI
import Combine

struct CategoryListContainerView: View {
    
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        let snackbarDataBinding = Binding<SnackbarModifier.SnackbarData>(
            get: { () -> SnackbarModifier.SnackbarData in
                return self.store.state.snackbarData
            },
            set:  { _ in }
        )
 
        let snackbarShowingBinding = Binding<Bool>(
            get: { () -> Bool in
                return self.store.state.showSnackbar
            },
            set:  { _ in
                self.store.send(.hideError)
            }
        )
        
        return NavigationView {
            CategoryListView(
                categoryList: store.state.categoryList
            )
            .navigationBarTitle("Categories")
            .navigationViewStyle(StackNavigationViewStyle())
            .snackbar(data: snackbarDataBinding, show: snackbarShowingBinding)
        }
        .onAppear(perform: fetchCategoryList)
    }
    
    private func fetchCategoryList() {
        store.send(.fetchCategoryList)
    }
}

private struct CategoryListView: View {
    
    let categoryList: [Category]
    
    var body: some View {
        List {
            ForEach(categoryList) { category in
                NavigationLink(destination: AppListContainerView(category: category)) {
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
        return CategoryListView(categoryList: list)
    }
}
#endif
