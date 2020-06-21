//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
    let store: MainStore

    @State private var showUpdateConfirmation: Bool = false
    @State private var showResetConfirmation: Bool = false
    @State private var remoteRepository: String = settingsManager.configuration.contentLocation.remoteURL.absoluteString
    @State private var branch: String = settingsManager.configuration.contentLocation.branch

    var body: some View {
        WithViewStore(self.store) { viewStore in
            Form {
                Section(header: Text("Switch content repository: Please only use https and a public repository. The Git client is not ready to handle any other configurations (yet) 😊")) {
                    TextField("URL of the content repository", text: self.$remoteRepository)

                    TextField("Branch", text: self.$branch)
                        .autocapitalization(.none)

                    Button(action: {
                        guard let remoteURL = URL(string: self.remoteRepository) else {
                            viewStore.send(.showMessage(title: "Error!", message: "Invalid URL", type: .error))
                            return
                        }

                        guard remoteURL != settingsManager.configuration.contentLocation.remoteURL ||
                            self.branch != settingsManager.configuration.contentLocation.branch else {
                            viewStore.send(.showMessage(
                                title: nil,
                                message: "You should not reclone the current repository 😉",
                                type: .info
                                )
                            )
                            return
                        }

                        viewStore.send(.switchContent(remoteURL, self.branch))
                    }) {
                        Text("Checkout")
                    }
                }

                Section(header: Text("Content")) {
                    Text("Update content")
                        .onTapGesture {
                            self.showUpdateConfirmation.toggle()
                        }

                    Text("Reset content")
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
                            message: Text("Do you want to pull the content from the remote repository?"),
                            buttons: [
                                .default(Text("Yes"), action: {
                                    viewStore.send(.updateContent)
                                }),
                                .cancel(),
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
                                .cancel(),
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
