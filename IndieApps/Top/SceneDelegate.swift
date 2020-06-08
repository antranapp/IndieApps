//
//  Copyright © 2020 An Tran. All rights reserved.
//

import ComposableArchitecture
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        UITableView.appearance().tableFooterView = UIView()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let contentView = AppRootView(store: AppStore(
            initialState: .init(),
            reducer: appReducer,
            environment: World()
        ))
        .environment(\.managedObjectContext, context)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

