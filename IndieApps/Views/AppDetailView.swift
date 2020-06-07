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
                    app.previews.map {AppPreviewsView(previews: $0)}
                    
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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Screenshots")
                .font(.title)
                .padding(.vertical, 8)
            
            ForEach(previews) {
                self.makePreview($0)
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
        let app = App(
            version: 1,
            id: UUID().uuidString,
            name: "Twitter",
            shortDescription: "Twitter is cool",
            description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.",
            links: [
                .homepage("https://antran.app"),
                .testflight("https://antran.app"),
                .appstore("https://antran.app")
            ],
            previews: [
                .web(["https://ph-files.imgix.net/0b48f11b-858b-431e-94c7-5a8dbead8bbe.png", "https://ph-files.imgix.net/0b48f11b-858b-431e-94c7-5a8dbead8bbe.png"]),
                .iOS(["https://is2-ssl.mzstatic.com/image/thumb/Purple123/v4/a4/0d/57/a40d573a-5621-e0e7-c051-34d9487a7e77/pr_source.jpg/460x0w.jpg", "https://is2-ssl.mzstatic.com/image/thumb/Purple123/v4/a4/0d/57/a40d573a-5621-e0e7-c051-34d9487a7e77/pr_source.jpg/460x0w.jpg"])
            ],
            releaseNotes: [
                ReleaseNote(version: "1.0.0 (1)", note: "Fix a lot of bugs"),
                ReleaseNote(version: "1.0.0 (2)", note: "Fix a lot of bugs"),
            ]
        )
        return AppDetailView(app: app)
    }
}
#endif
