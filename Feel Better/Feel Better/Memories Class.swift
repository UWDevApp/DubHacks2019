//
//  Memories Class.swift
//  Feel Better
//
//  Created by Lucas Wang on 2019-10-12.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit

// The class for memeories stored as objects in local array and FireBase
protocol MemoryType {
    var title: String { get }
    var content: String { get }
    var sentiment: Int { get }
    var saveDate: Date { get }
}

extension MemoryType {
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
            fatalError("This should never happen")
        }
    }
}

@available(*, deprecated, renamed: "LocalMemory")
typealias Memory = LocalMemory

struct LocalMemory: MemoryType {
    var title: String
    var content: String
    var sentiment: Int
    var saveDate: Date
    var image: UIImage?
}

struct CloudMemory: MemoryType {
    let documentID: String
    
    let title: String
    let content: String
    let sentiment: Int
    let tags: [String]
    let saveDate: Date
    let imageURL: URL?
}
