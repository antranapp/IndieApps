//
//  Copyright © 2020 An Tran. All rights reserved.
//

import SwiftUI
import UIKit

struct ActivityIndicator: View {
    
    var body: some View {
        UIViewRepresented { _ in
            let view = UIActivityIndicatorView()
            view.startAnimating()
            return view
        }
    }
    
}
