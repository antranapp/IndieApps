//
//  Copyright © 2020 An Tran. All rights reserved.
//

import KingfisherSwiftUI
import SwiftUI

struct AppPreviewGalleryView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var preview: Preview
    
    @State private var index = 0
        
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                PagingView(index: self.$index.animation(), maxIndex: self.preview.links.count - 1) {
                    self.makeImagePreview(links: self.preview.links, geometry: geometry)
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: { Text("Close") }))
        }
    }
    
    // MARK: Private helpers
    
    private func makeImagePreview(links: [String], geometry: GeometryProxy) -> some View {
        return ForEach(links, id: \.self) {
            URL(string: $0).map {
                KFImage($0)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}
