//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
    
    let store: MainStore
    
    @State private var showUpdateConfirmation: Bool = false
    @State private var showResetConfirmation: Bool = false
    @State private var remoteRepository: String = configuration.contentLocation.remoteURL.absoluteString
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Form {
                Section(header: Text("Switch content repository: Please only use https and public repository. The Git client is not ready to handle any other configurations (yet) 😊")) {
                    TextField("URL of the content repository", text: self.$remoteRepository)
                    Button(action: {
                        print("should checkout \(self.remoteRepository)")
                                                
                        guard let remoteURL = URL(string: self.remoteRepository) else {
                            viewStore.send(.showMessage(title: "Error!", message: "Invalid URL", type: .error))
                            return
                        }
                        
                        guard remoteURL != Configuration.Default.mainContentRepositoryURL else {
                            viewStore.send(.showMessage(title: nil, message: "You should not reclone the default repository! Use your fork or other's forks 😉)", type: .info))
                            return
                        }

                        let configuration = Configuration(
                            rootFolderURL: Configuration.Default.rootFolderURL,
                            archiveURL: nil,
                            remoteRepositoryURL: remoteURL)
                        viewStore.send(.switchContent(configuration))
                    }) {
                        Text("Checkout")
                    }
                }

                Section {
                    Text("Update")
                        .onTapGesture {
                            self.showUpdateConfirmation.toggle()
                    }
                    Text("Reset")
                        .foregroundColor(Color.red)
                        .onTapGesture {
                            self.showResetConfirmation.toggle()
                    }
                }
            }
            .background(
                EmptyView()
                    .actionSheet(isPresented: self.$showUpdateConfirmation) {
                        ActionSheet(
                            title: Text("Confirmation"),
                            message: Text("Update the content?"),
                            buttons: [
                                .default(Text("Yes"), action: {
                                    viewStore.send(.updateContent)
                                }),
                                .cancel()
                            ]
                        )
                }
            )
            .background(
                EmptyView()
                    .actionSheet(isPresented: self.$showResetConfirmation) {
                        ActionSheet(
                            title: Text("Confirmation"),
                            message: Text("Do you really want to reset the content?"),
                            buttons: [
                                .destructive(Text("Yes"), action: {
                                    viewStore.send(.resetContent)
                                }),
                                .cancel()
                            ]
                        )
                }
            )
            .navigationBarTitle("Settings")
            .snackbar(
                data: viewStore.binding(
                    get: { $0.snackbarData },
                    send: { _ in MainAction.hideSnackbar }
                )
            )
        }
    }
}
