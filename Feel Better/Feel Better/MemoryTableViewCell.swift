//
//  MemoryTableViewCell.swift
//  Feel Better
//
//  Created by Lucas Wang on 2019-10-12.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit

class MemoryTableViewCell: UITableViewCell {

	@IBOutlet weak var memoryCellTitle: UILabel!
	@IBOutlet weak var memoryCellEmoji: UILabel!
	@IBOutlet weak var memoryCellDateString: UILabel!
	@IBOutlet weak var memoryCellUIImage: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
