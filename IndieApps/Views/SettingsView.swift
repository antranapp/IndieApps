//
//  Copyright © 2020 An Tran. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var store: AppStore
    
    @State private var showUpdateConfirmation: Bool = false
    @State private var showResetConfirmation: Bool = false
    
    var body: some View {
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
                                self.store.send(.updateContent)
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
                                self.store.send(.resetContent)
                            }),
                            .cancel()
                        ]
                    )
            }
        )
        .navigationBarTitle("Settings")
    }
}
