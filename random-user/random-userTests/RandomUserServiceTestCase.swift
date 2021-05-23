//
//  RandomUserServiceTestCase.swift
//  random-userTests
//
//  Created by Zeljko Nikolic on 21.5.21..
//

import XCTest
@testable import Random_user

final class RandomUserServiceTestCase: XCTestCase {
    
    let timeout: TimeInterval = 20
    var expectation: XCTestExpectation!

    override func setUp() {
        expectation = expectation(description: "Server responds in reasonable time")
    }
    
    func test_wrongUrl() {
        let sut = RandomUserService(client: FakeWebClient(baseUrl: "https://wrongurl.rs"))
        sut.getRandomUsers(numberOfUsers: 20, page: 1) { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error)
            }
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    func test_RandomUserService_NoData() {
        let sut = RandomUserService(client: FakeWebClient(baseUrl: "noData"))
        sut.getRandomUsers(numberOfUsers: 20, page: 1) { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error)
            }
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    func test_RandomUserService_error() {
        let sut = RandomUserService(client: FakeWebClient(baseUrl: "error"))
        sut.getRandomUsers(numberOfUsers: 20, page: 1) { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error)
            }
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    func test_RandomUserService_success() {
        let sut = RandomUserService(client: FakeWebClient(baseUrl: Constants.randomUserBaseUrl))
        sut.getRandomUsers(numberOfUsers: 20, page: 1) { result in
            if case .success(let randomUserResponse) = result {
                XCTAssertNotNil(randomUserResponse)
            }
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    func test_RandomUserService_NetworkCall_success() {
        let sut = RandomUserService(client: WebClient(baseUrl: Constants.randomUserBaseUrl))
        sut.getRandomUsers(numberOfUsers: 20, page: 1) { result in
            if case .success(let randomUserResponse) = result {
                XCTAssertNotNil(randomUserResponse)
            }
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    
    //MARK: - FakeWebClient
    class FakeWebClient: WebClient {
        override func load(path: String?, method: RequestMethod, queryParams: JSONDictionary?, bodyParams: Data?, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            var data: Data
            switch baseUrl {
                case Constants.randomUserBaseUrl:
                    let testBundle = Bundle(for: RandomUserServiceTestCase.self)
                    do {
                        let url = try XCTUnwrap(
                            testBundle.url(forResource: "allUsersData", withExtension: "json")
                        )
                        data = try Data(contentsOf: url)
                        completion(data, HTTPURLResponse( url: URL(string: Constants.randomUserBaseUrl)!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
                    } catch { }
                case "noData":
                    completion(nil, HTTPURLResponse( url: URL(string: "noData")!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
                case "error":
                    let error = NSError(domain: "error", code: -2, userInfo: nil)
                    completion(nil, HTTPURLResponse( url: URL(string: "noData")!, statusCode: 200, httpVersion: nil, headerFields: nil), error)
                default:
                    data = Data()
                    completion(data, HTTPURLResponse( url: URL(string: "dummyURL")!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
            }
        }
    }

}

