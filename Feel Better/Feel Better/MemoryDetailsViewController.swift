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
    
    var memoryFromSegue: MemoryType?
    
    func adjustUITextViewHeight(arg : UITextView){
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let memory = memoryFromSegue {
            memoryDetailsTitle.text = memory.title
            memoryDetailsDateString.text = DateFormatter.feelBetter.string(from: memory.saveDate)
            memoryDetailsEmoji.text = memory.sentimentEmoji
            memoryDetailsContent.text = memory.content
            adjustUITextViewHeight(arg: memoryDetailsContent)
            switch memory {
            case let local as LocalMemory:
                memoryDetailsImage.isHidden = local.image == nil
                memoryDetailsImage.image = local.image
            case let cloud as CloudMemory:
                memoryDetailsImage.isHidden = cloud.imageURL == nil
                memoryDetailsImage.kf.setImage(with: cloud.imageURL)
            default:
                fatalError("what memory?")
            }
        }
    }
}
