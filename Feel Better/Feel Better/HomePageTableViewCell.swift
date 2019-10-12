//
//  HomePageTableViewCell.swift
//  Feel Better
//
//  Created by Kevin Tong on 2019/10/12.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit
import Charts

class HomePageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: BarChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
