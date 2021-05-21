//
//  Array+Extensions.swift
//  Random-user
//
//  Created by Zeljko Nikolic on 21.5.21..
//

import Foundation

extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}
