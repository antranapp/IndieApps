//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
    
    let store: MainStore
    
    @State private var showUpdateConfirmation: Bool = false
    @State private var showResetConfirmation: Bool = false
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Form {
                Section(header: Text("Content")) {
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
