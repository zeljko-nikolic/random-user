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
        vc.delegate = self
        rootViewController.setViewControllers([vc], animated: true)
    }
    
}

//MARK: - AllUsersViewControllerDelegate
extension AppCoordinator: AllUsersViewControllerDelegate {
    
    func allUsersViewController(_ allUsersViewController: AllUsersViewController, didSelect user: User) {
        let vc = UserViewController()
        vc.user = user
        rootViewController.show(vc, sender: self)
    }
    
}
