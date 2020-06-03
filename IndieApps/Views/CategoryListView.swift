//
//  Copyright © 2020 An Tran. All rights reserved.
//

import SwiftUI

struct CategoryListView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(categoryList) { category in
                    NavigationLink(destination: AppListView(category: category)) {
                        CategoryView(category: category)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationBarTitle("Categories")
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}


#if DEBUG
struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
#endif
