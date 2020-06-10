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
                PagingView(index: self.$index.animation(), maxIndex: 2) {
                    self.makePreview(self.preview, geometry: geometry)
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: { Text("Close") }))
        }
    }
    
    // MARK: Private helpers
    
    private func makePreview(_ preview: Preview, geometry: GeometryProxy) -> some View {
        switch preview {
            case .web(let links):
                return makeImagePreview(title: "web", links: links, geometry: geometry)
            case .macOS(let links):
                return makeImagePreview(title: "macOS", links: links, geometry: geometry)
            case .iOS(let links):
                return makeImagePreview(title: "iOS", links: links, geometry: geometry)
            case .iPadOS(let links):
                return makeImagePreview(title: "iPadOS", links: links, geometry: geometry)
            case .watchOS(let links):
                return makeImagePreview(title: "watchOS", links: links, geometry: geometry)
            case .tvOS(let links):
                return makeImagePreview(title: "tvOS", links: links, geometry: geometry)
        }
    }
    
    private func makeImagePreview(title: String, links: [String], geometry: GeometryProxy) -> some View {
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
