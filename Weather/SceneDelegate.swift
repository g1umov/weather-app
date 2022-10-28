//
//  SceneDelegate.swift
//  Weather
//
//  Created by Vladislav on 24.10.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window!.rootViewController = UIViewController()
        window!.makeKeyAndVisible()
    }

}
