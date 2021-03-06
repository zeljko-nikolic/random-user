//
//  UserViewControllerTestCase.swift
//  Random-userTests
//
//  Created by Zeljko Nikolic on 23.5.21..
//

import XCTest
@testable import Random_user

final class UserViewControllerTestCase: XCTestCase {
    
    var user: User!
    
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
        user = nil
    }
    
    func test_ViewLoading() {
        let sut = UserViewController()
        sut.user = user
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.nameLabel.text, "Zeljko Nikolic")
        XCTAssertEqual(sut.ageLabel.text, "Age: 30")
        XCTAssertEqual(sut.emailLabel.text, "zeksa90@gmail.com")
    }
    
    func test_delegateCall() {
        let sut = UserViewController()
        sut.user = user
        let spyDelegate = SpyUserViewControllerDelegate()
        sut.delegate = spyDelegate
        sut.loadViewIfNeeded()
        
        XCTAssertNil(spyDelegate.email)
        sut.onEmailTapped()
        XCTAssertNotNil(spyDelegate.email)
    }

    class SpyUserViewControllerDelegate: UserViewControllerDelegate {
        var email: String?
        func userViewController(_ userViewController: UserViewController, didTapOn email: String) {
            self.email = email
        }
    }
    
}
