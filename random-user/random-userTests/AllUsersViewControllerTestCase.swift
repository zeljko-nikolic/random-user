//
//  AllUsersViewControllerTestCase.swift
//  Random-userTests
//
//  Created by Zeljko Nikolic on 23.5.21..
//

import XCTest
@testable import Random_user

final class AllUsersViewControllerTestCase: XCTestCase {

    func test_ViewLoading() {
        let sut = AllUsersViewController()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.title, "All users")
    }
}
