//
//  SceneDelegate.swift
//  Messenger
//
//  Created by Kaan Turan on 30.08.2022.
//

import UIKit
import SnapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let mainController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: mainController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}

