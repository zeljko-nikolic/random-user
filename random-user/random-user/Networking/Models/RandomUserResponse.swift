//
//  RandomUserResponse.swift
//  Random-user
//
//  Created by Zeljko Nikolic on 21.5.21..
//

import UIKit

struct RandomUserResponse: Codable {
    var results: [User] = []
    let info: Info
}
