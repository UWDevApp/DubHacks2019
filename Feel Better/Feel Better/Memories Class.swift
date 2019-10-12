//
//  Memories Class.swift
//  Feel Better
//
//  Created by Lucas Wang on 2019-10-12.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit

// The class for memeories stored as objects in local array and FireBase
class Memory {
	var title: String
	var content: String
	var sentiment: Int
	var saved_date: Date
	var image: UIImage?
	
	init? (title: String, content: String, sentiment: String, saved_date: Date, image: UIImage?)
	
	self.title = title
	self.content = content
	self.sentiment = sentiment
	self.saved_date = saved_date
	self.image = image
	
	guard !title.isEmpty else {
		return nil
	}
}
