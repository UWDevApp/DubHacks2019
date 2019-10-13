//
//  String+Extensions.swift
//  WordCram
//
//  Created by Slava Semeniuk on 4/1/19.
//  Copyright © 2019 eKreative. All rights reserved.
//

import Foundation

extension String {
    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length - 1).map{ _ in letters.randomElement()! })
    }
}
