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
        setupAllUsersScene()
    }
    
    func setupAllUsersScene() {
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
        vc.delegate = self
        rootViewController.show(vc, sender: self)
    }
    
}

//MARK: - UserViewControllerDelegate
extension AppCoordinator: UserViewControllerDelegate {
    
    func userViewController(_ userViewController: UserViewController, didTapOn email: String) {
        print("GoToEmail")
    }

}
