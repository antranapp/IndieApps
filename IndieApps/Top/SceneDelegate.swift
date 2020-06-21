//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        UITableView.appearance().tableFooterView = UIView()

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let mainState = MainState()
        let contentView = AppRootView(store: MainStore(
            initialState: mainState,
            reducer: mainReducer,
            environment: MainEnvironment(
                configurationProvider: { configuration },
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        ))
            .environment(\.managedObjectContext, context)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidEnterBackground(_: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
