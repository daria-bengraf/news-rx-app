//
//  AppCoordinator.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 01.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import UIKit
class AppCoordinator {
    
    private var window = UIWindow()
    
    init(window:UIWindow) {
        self.window = window
    }
    
    func start() {
        window.makeKeyAndVisible()
        let controller = NewsListTestController()

        window.rootViewController = UINavigationController(rootViewController: controller)
    }
}

