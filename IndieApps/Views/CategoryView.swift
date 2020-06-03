//
//  Copyright © 2020 An Tran. All rights reserved.
//

import SwiftUI

struct CategoryView: View {
    
    var category: Category
    
    var body: some View {
        HStack {
            Image(systemName: "clock")
            Text(category.name)
        }
    }
}
