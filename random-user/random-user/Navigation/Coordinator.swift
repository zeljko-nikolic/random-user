//
//  Coordinator.swift
//  Random-user
//
//  Created by Zeljko Nikolic on 21.5.21..
//

import UIKit

class Coordinator: NSObject {
    
    var window: UIWindow?
    var rootViewController: UINavigationController
    var parentCoordinator: Coordinator!
    
    private(set) var childCoordinators: [Coordinator] = []
        
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    convenience init(window: UIWindow?) {
        self.init(rootViewController: UINavigationController())
        self.window = window
    }
    
    func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
    func addChildAndStart(_ coordinator: Coordinator) {
        self.childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func coordinatorFinished() {
        parentCoordinator.onChildCoordinatorFinished(self)
    }
    
    func onChildCoordinatorFinished(_ coordinator: Coordinator) {
        removeChildCoordinator(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator, animated: Bool = true) {
        rootViewController.popViewController(animated: true)
        childCoordinators.remove(object: coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        coordinator.removeAllChildCoordinators()
        childCoordinators.remove(object: coordinator)
    }

    func removeAllChildCoordinators() {
        for coordinator in childCoordinators {
            coordinator.removeAllChildCoordinators()
        }
        childCoordinators.removeAll()
    }
    
}

