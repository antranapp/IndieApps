//
//  Copyright © 2020 An Tran. All rights reserved.
//

import KingfisherSwiftUI
import SwiftUI

struct AppDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var app: App
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // Meta data
                    HStack(alignment: .top) {
                        Image(uiImage: app.iconOrDefaultImage)
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .leading)
                            .cornerRadius(17.5)
                            .overlay(RoundedRectangle(cornerRadius: 17.5)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 0.5))

                        VStack(alignment: .leading) {
                            Text(app.name)
                                .font(.system(size: 21, weight: .bold, design: .default)).bold()
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.leading)
                                .padding(.bottom, 8)
                            Text(app.shortDescription)
                                .font(.body)
                                .foregroundColor(Color.black.opacity(0.2))

                        }
                        .padding(.leading, 8)
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    
                    // Links
                    AppLinksView(links: app.links)
                        .padding(.bottom, 8)
                    
                    
                    // Previews
                    app.previews.map { AppPreviewsView(previews: $0) }
                    
                    // Description
                    Group {
                        Text("Description")
                            .font(.title)
                            .padding(.vertical, 8)
                        Text(app.description)
                            .font(.body)
                    }
                    .padding(.bottom, 8)

                    // Version history
                    AppVersionHistoryView(releaseNotes: app.releaseNotes)
                        .padding(.bottom, 8)

                }
                .padding()
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: { Text("Close") }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AppLinksView: View {
    
    var links: [Link]
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                ForEach(links) { link in
                    Button(action: {
                        guard let url = URL(string: link.value) else { return }
                        UIApplication.shared.open(url)
                    }) {
                        Text(link.type.uppercased())
                            .lineLimit(1)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                        
                    }
                    .background(Color.blue)
                    .cornerRadius(30)
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
    }
}

struct AppPreviewsView: View {
    
    var previews: [Preview]
    
    @State private var selection: Preview?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Screenshots")
                .font(.title)
                .padding(.vertical, 8)
            
            ForEach(previews) { preview in
                Group {
                    self.makePreview(preview)
                    NavigationLink(destination: AppPreviewGalleryView(preview: preview), tag: preview, selection: self.$selection) {
                        EmptyView()
                    }.hidden()
                }
                .onTapGesture {
                    self.selection = preview
                }
            }
        }
    }
    
    // MARK: Private helpers
    
    private func makePreview(_ preview: Preview) -> some View {
        switch preview {
            case .web(let links):
                return makeImagePreview(title: "web", links: links)
            case .macOS(let links):
                return makeImagePreview(title: "macOS", links: links)
            case .iOS(let links):
                return makeImagePreview(title: "iOS", links: links)
            case .iPadOS(let links):
                return makeImagePreview(title: "iPadOS", links: links)
            case .watchOS(let links):
                return makeImagePreview(title: "watchOS", links: links)
            case .tvOS(let links):
                return makeImagePreview(title: "tvOS", links: links)
        }
    }
    
    private func makeImagePreview(title: String, links: [String]) -> some View {
        return VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(links, id: \.self) {
                        URL(string: $0).map {
                            KFImage($0)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 220)
                        }
                    }
                }
            }
        }
    }
}

struct AppVersionHistoryView: View {
    
    var releaseNotes: [ReleaseNote]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Release Notes")
                .font(.title)
                .padding(.vertical, 8)
            
            ForEach(releaseNotes) { releaseNote in
                Text(releaseNote.version)
                    .font(.headline)
                Text(releaseNote.note)
                    .font(.subheadline)
                
                Divider()
            }
        }
    }
}

#if DEBUG
struct AppDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let app = MockContentSevice.appList[0]
        return AppDetailView(app: app)
    }
}
#endif
