//
//  Word.swift
//  Feel Better
//
//  Created by Kevin Tong on 2019/10/12.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import Foundation
import UIKit

struct Word {
    let text: String

    let attributes: [NSAttributedString.Key: Any]
    let size: CGSize

    init(text: String, font: UIFont, color: UIColor) {
        self.text = text
        self.attributes = [.font: font,
                           .foregroundColor: color,]
        self.size = (text as NSString).size(withAttributes: attributes)
    }
}
