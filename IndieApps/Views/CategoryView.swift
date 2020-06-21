//
//  Copyright © 2020 An Tran. All rights reserved.
//

import SwiftUI

struct CategoryView: View {
    var category: Category

    var body: some View {
        HStack {
            Text(category.name)
            Spacer()
            if category.numberOfApps > 0 {
                Text(category.numberOfApps.asString)
                    .foregroundColor(Color.black.opacity(0.3))
            }
        }
    }
}
