//
//  ImageTagMemory.swift
//  Feel Better
//
//  Created by Apollo Zhu on 10/13/19.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import Foundation
import Photos

public class ImageTagMemory {
    private static let shared = ImageTagMemory()
    private init() { }
    
    public typealias ImageTag = (tags: Set<String>, description: String?)

    public static subscript(_ asset: PHAsset) -> ImageTag? {
        get {
            defer { shared.lock.unlock() }
            shared.lock.lock()
            return shared.tag(of: asset)
        }
        set {
            defer { shared.lock.unlock() }
            shared.lock.lock()
            shared.setTag(newValue, for: asset)
        }
    }
    
    private let lock = NSLock()
    
    private func tag(of asset: PHAsset) -> ImageTag? {
        let identifier = asset.localIdentifier
        if let array = UserDefaults.standard.stringArray(forKey: "ImageTagKey_tags_\(identifier)") {
            let desc = UserDefaults.standard.string(forKey: "ImageTagKey_desc_\(identifier)")
            return ImageTag(Set(array), desc)
        } else { return nil }
    }
    
    private func setTag(_ tag: ImageTag?, for asset: PHAsset) {
        guard let tag = tag else { return }
        let identifier = asset.localIdentifier
        UserDefaults.standard.set(Array(tag.tags), forKey: "ImageTagKey_tags_\(identifier)")
        UserDefaults.standard.set(tag.description, forKey: "ImageTagKey_desc_\(identifier)")
    }
}
