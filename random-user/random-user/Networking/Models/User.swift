//
//  User.swift
//  Random-user
//
//  Created by Zeljko Nikolic on 21.5.21..
//

import Foundation

struct User: Codable {
    let name: Name
    let dateOfBirth: DateOfBirth
    let picture: Picture
    let nationality: String
    let email: String
    
    var nationalityFlag: String {
        let base : UInt32 = 127397
        var s = ""
        for v in nationality.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case dateOfBirth = "dob"
        case picture
        case nationality = "nat"
        case email
    }
}
