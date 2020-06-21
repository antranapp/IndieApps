//
//  Copyright © 2020 An Tran. All rights reserved.
//

import SwiftUI
import UIKit

struct UIViewRepresented<UIViewType>: UIViewRepresentable where UIViewType: UIView {
    let makeUIView: (Context) -> UIViewType
    let updateUIView: (UIViewType, Context) -> Void = { _, _ in }

    func makeUIView(context: Context) -> UIViewType {
        makeUIView(context)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        updateUIView(uiView, context)
    }
}
