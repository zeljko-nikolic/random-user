//
//  AppCoordinatorTestCase.swift
//  Random-userTests
//
//  Created by Zeljko Nikolic on 23.5.21..
//

import XCTest
@testable import Random_user
@testable import MessageUI

final class AppCoordinatorTestCase: XCTestCase {
    
    var user: User!
    var sut: AppCoordinator!
    
    override func setUp() {
        user = User(name: Name(title: "Dr.Mr.",
                               first: "Zeljko",
                               last: "Nikolic"),
                    dateOfBirth: DateOfBirth(date: Date(), age: 30),
                    picture: Picture(large: "https://img.rs",
                                     medium: "https://img.rs",
                                     thumbnail: "https://img.rs"),
                    nationality: "RS",
                    email: "zeksa90@gmail.com",
                    login: Login(uuid: UUID().uuidString))
    }
    
    override func tearDown() {
        sut = nil
        user = nil
    }
    
    func test_coordinatorFlow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        sut = AppCoordinator(window: window)
        sut.start()
        RunLoop.current.run(until: Date())
        
        guard let allUsersVc = sut.rootViewController.topViewController as? AllUsersViewController else {
            XCTFail("AllUsersViewController is not pushed on the stack")
            return
        }
        allUsersVc.delegate?.allUsersViewController(allUsersVc, didSelect: user)
        RunLoop.current.run(until: Date())
        
        guard let userVC = sut.rootViewController.topViewController as? UserViewController else {
            XCTFail("UserViewController is not pushed on the stack")
            return
        }
        
        userVC.onEmailTapped()
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.3))
        
        if MFMailComposeViewController.canSendMail() {
            XCTAssert(sut.rootViewController.presentedViewController is MFMailComposeViewController)
        }
        else {
            XCTAssert(sut.rootViewController.presentedViewController is UIAlertController)
        }
    }
    
}
