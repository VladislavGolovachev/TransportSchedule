//
//  SceneDelegate.swift
//  TransportSchedule
//
//  Created by Владислав Головачев on 24.10.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, 
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let vc = ViewController()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = vc
        
        window?.makeKeyAndVisible()
    }
}

