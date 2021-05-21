//
//  AppCoordinator.swift
//  Random-user
//
//  Created by Zeljko Nikolic on 21.5.21..
//

import UIKit

class AppCoordinator: Coordinator {

    override func start() {
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()
        setupWelcomeScene()
    }
    
    func setupWelcomeScene() {
        let vc = AllUsersViewController()
        
        rootViewController.setViewControllers([vc], animated: true)
    }
    
}
