//
//  ImageSuggestionProvider.swift
//  Feel Better
//
//  Created by Apollo Zhu on 10/12/19.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Combine

public class ImageSuggestion: NSObject {
    public static let provider = ImageSuggestion()
    private override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    public typealias ImageHandler = ([UIImage]) -> Void
    
    /// - Parameters:
    ///   - process: this callback is **NOT** on the main thread.
    public func relevantImage(between startDate: Date,
                              and endDate: Date,
                              for text: String,
                              then process: @escaping ImageHandler) {
        TextAnalzyer.keyPhrases(in: text) { [unowned self] (result) in
            switch result {
            case .success(let keyPhrases):
                self.queue.async { [unowned self] in
                    self.image(matching: Set(keyPhrases), between: startDate, and: endDate, then: process)
                }
            case .failure:
                process([])
            }
        }
    }
    
    private let manager = PHImageManager.default()
    private let queue = DispatchQueue(label: #function, qos: .userInitiated, attributes: .concurrent)
    
    private static var tags: [String: Set<String>] = [:]
    
    private func image(matching keyPhrases: Set<String>,
                       between startDate: Date,
                       and endDate: Date,
                       then process: @escaping ImageHandler) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@",
                                             startDate as NSDate, endDate as NSDate)
        
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        guard assets.count > 0 else { return process([]) }
        
        let semaphore = DispatchSemaphore(value: assets.count)
        let lock = NSLock()
        var images = [UIImage]()
        
        for i in 0..<assets.count {
            let asset = assets.object(at: i)
            // asset.localIdentifier
            manager.requestImageDataAndOrientation(for: asset, options: .allowNetworkAccess)
            { (data, string, orientation, info) in
                defer { semaphore.signal() }
                
                guard let data = data else { return }
                guard let image = UIImage(data: data) else { return }
                
                lock.lock()
                images.append(image)
                lock.unlock()
            }
        }
        semaphore.wait()
        
        #warning("Process")
    }
}

extension PHImageRequestOptions {
    fileprivate static let allowNetworkAccess: PHImageRequestOptions = {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isNetworkAccessAllowed = true
        return requestOptions
    }()
}

extension ImageSuggestion: PHPhotoLibraryChangeObserver {
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        // MARK: TODO: handle changes
    }
}
