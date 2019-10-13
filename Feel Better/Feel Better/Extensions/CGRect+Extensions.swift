//
//  CGRect+Extensions.swift
//  WordCram
//
//  Created by Slava Semeniuk on 3/11/19.
//  Copyright © 2019 eKreative. All rights reserved.
//

import CoreGraphics

extension CGRect {
    func reversedY(with size: CGSize) -> CGRect {
        return CGRect(x: origin.x, y: size.height - origin.y - height, width: width, height: height)
    }
}

