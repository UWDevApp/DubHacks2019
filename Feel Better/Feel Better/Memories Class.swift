//
//  Memories Class.swift
//  Feel Better
//
//  Created by Lucas Wang on 2019-10-12.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit

// The class for memeories stored as objects in local array and FireBase
struct Memory {
	var title: String
	var content: String
	var sentiment: Int
	var saveDate: Date
	var image: UIImage?
	
	var sentimentEmoji: String {
		switch sentiment {
			case ..<20:
				return "😭"
			case 20..<40:
				return "☹️"
			case 40..<60:
				return "😐"
			case 60..<80:
				return "🙂"
			case 80...:
				return "😄"
			default:
				return "GG"
		}
	}
}
