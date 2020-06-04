//
//  Copyright © 2020 An Tran. All rights reserved.
//

import SwiftUI

struct AppDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var app: App
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Image(uiImage: app.icon ?? UIImage())
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
                                .padding(.bottom, 5)
                            Text(app.shortDescription)
                                .font(.body)
                                .foregroundColor(Color.black.opacity(0.2))

                        }
                        .padding(.leading, 8)
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    
                    Group {
                        Text("Description")
                            .font(.title)
                            .padding(.vertical, 8)
                        Text(app.description)
                            .font(.body)
                    }
                    .padding(.bottom, 8)

                    Group {
                        Text("Version History")
                            .font(.title)
                            .padding(.vertical, 8)

                        ForEach(app.releaseNotes) { releaseNote in
                            Text(releaseNote.version)
                                .font(.headline)
                            Text(releaseNote.note)
                                .font(.subheadline)
                            
                            Divider()
                        }
                    }
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

#if DEBUG
struct AppDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let app = App(
            id: UUID().uuidString,
            name: "Twitter",
            shortDescription: "Twitter is cool",
            description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.",
            releaseNotes: [
                ReleaseNote(id: UUID().uuidString, version: "1.0.0 (1)", note: "Fix a lot of bugs"),
                ReleaseNote(id: UUID().uuidString, version: "1.0.0 (2)", note: "Fix a lot of bugs"),
            ]
        )
        return AppDetailView(app: app)
    }
}
#endif
