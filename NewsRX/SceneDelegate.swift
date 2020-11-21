//
//  SceneDelegate.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 01.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

   var window: UIWindow?

       var appCoordinator: AppCoordinator?

       func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
           
           guard let scene = (scene as? UIWindowScene) else { return }
           let window = UIWindow(windowScene: scene)
           
           appCoordinator = AppCoordinator(window: window)
           appCoordinator?.start()
           
       }
       


   }
