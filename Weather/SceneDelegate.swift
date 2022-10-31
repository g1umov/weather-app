//
//  SceneDelegate.swift
//  Weather
//
//  Created by Vladislav on 24.10.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        coordinator = AppCoordinator(navigationController: .init(), viewControllersFactory: .init())
        coordinator!.configure()
        
        window = UIWindow(windowScene: windowScene)
        window!.rootViewController = coordinator!.viewController
        window!.makeKeyAndVisible()
    }
    
}
