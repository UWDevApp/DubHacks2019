//
//  MemoryTableViewCell.swift
//  Feel Better
//
//  Created by Lucas Wang on 2019-10-12.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit
import Kingfisher

// Configure dateFormatter
extension DateFormatter {
    static let feelBetter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss")
        return dateFormatter
    }()
}

class MemoryTableViewCell: UITableViewCell {
    @IBOutlet private weak var memoryCellTitle: UILabel!
    @IBOutlet private weak var memoryCellText: UILabel!
    @IBOutlet private weak var memoryCellEmoji: UILabel!
    @IBOutlet private weak var memoryCellDateString: UILabel!
    @IBOutlet private weak var memoryCellUIImage: UIImageView!
    
    var memory: MemoryType?
    
    public func setMemory(_ memory: MemoryType) {
        self.memory = memory
        memoryCellTitle.text = memory.title
        memoryCellEmoji.text = memory.sentimentEmoji
        memoryCellText.text = memory.content
        memoryCellDateString.text = DateFormatter.feelBetter.string(from: memory.saveDate)
        switch memory {
        case let local as LocalMemory:
            memoryCellUIImage.isHidden = local.image == nil
            memoryCellUIImage.image = local.image
        case let cloud as CloudMemory:
            memoryCellUIImage.isHidden = cloud.imageURL == nil
            memoryCellUIImage.kf.setImage(with: cloud.imageURL)
        default:
            fatalError("what memory?")
        }
    }
}
