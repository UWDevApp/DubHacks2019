//
//  WordImage.swift
//  Feel Better
//
//  Created by Kevin Tong on 2019/10/12.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit

struct WordImage {
    let point: CGPoint
    let image: CGImage
    let word: Word

    var rect: CGRect {
        return CGRect(origin: point, size: word.size)
    }
}
