//
//  AppCoordinator.swift
//  Random-user
//
//  Created by Zeljko Nikolic on 21.5.21..
//

import UIKit
import MessageUI

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
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = self
            vc.setToRecipients([email])
            rootViewController.present(vc, animated: true)
        }
        else {
            let alert = UIAlertController(title: "Mail app unavailable", message: "There is no Mail app configured on this device, do you want to open the default email app?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { action in
                if let url = URL(string: "mailto:\(email)") {
                    UIApplication.shared.open(url)
                }
            })
            alert.addAction(cancel)
            alert.addAction(ok)
            rootViewController.present(alert, animated: true)
        }
    }
    
}

//MARK: - MFMailComposeViewControllerDelegate
extension AppCoordinator: MFMailComposeViewControllerDelegate {
   
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
