//
//  Copyright © 2020 An Tran. All rights reserved.
//

import SwiftUI
import Combine

struct CategoryListContainerView: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        NavigationView {
            CategoryListView(
                categoryList: store.state.categoryList
            )
            .navigationBarTitle("Categories")
            .navigationViewStyle(StackNavigationViewStyle())
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
                NavigationLink(destination: AppListView(category: category)) {
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
            Category(name: "Movies"),
            Category(name: "Photography")
        ]
        return CategoryListView(categoryList: list)
    }
}
#endif
