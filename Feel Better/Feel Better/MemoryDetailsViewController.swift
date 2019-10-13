//
//  MemoryDetails.swift
//  Feel Better
//
//  Created by Lucas Wang on 2019-10-12.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit

class MemoryDetailsViewController: UIViewController {
	
	@IBOutlet weak var memoryDetailsTitle: UILabel!
	@IBOutlet weak var memoryDetailsDateString: UILabel!
	@IBOutlet weak var memoryDetailsEmoji: UILabel!
	@IBOutlet weak var memoryDetailsContent: UITextView!
	@IBOutlet weak var memoryDetailsImage: UIImageView!
	
	let dateFormatter = DateFormatter()
	var memoryFromSegue: Memory?
	
	func adjustUITextViewHeight(arg : UITextView){
    arg.translatesAutoresizingMaskIntoConstraints = true
    arg.sizeToFit()
    arg.isScrollEnabled = false
    }
    
    override func viewDidLoad() {
		super.viewDidLoad()
		
		// Configure dateFormatter
		dateFormatter.locale = Locale(identifier: "en_US")
		dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss")
		
		if let memory = memoryFromSegue {
			memoryDetailsTitle.text = memory.title
			memoryDetailsDateString.text = dateFormatter.string(from: memory.saveDate)
			memoryDetailsEmoji.text = memory.sentimentEmoji
			memoryDetailsContent.text = memory.content
			adjustUITextViewHeight(arg: memoryDetailsContent)
			if memory.image != nil {
				memoryDetailsImage.image = memory.image
			} else {
				memoryDetailsImage.isHidden = true
			}
		}
	}
}
