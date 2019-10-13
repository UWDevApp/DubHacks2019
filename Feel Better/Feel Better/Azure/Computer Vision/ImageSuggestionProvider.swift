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

public class ImageSuggestionProvider: NSObject {
    public static let provider = ImageSuggestionProvider()
    private override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    public typealias ImageSuggestion = (UIImage, description: String)
    public typealias ImageHandler = ([ImageSuggestion]) -> Void
    
    /// - Parameters:
    ///   - process: this callback is **NOT** on the main thread.
    public func relevantImage(between startDate: Date,
                              and endDate: Date,
                              for text: String,
                              then process: @escaping ImageHandler) {
        TextAnalzyer.keyPhrases(in: text) { [unowned self] (result) in
            switch result {
            case .success(let keyPhrases):
                self.blockedQueue.async { [unowned self] in
                    self.image(matching: Set(keyPhrases.lazy.map { $0.lowercased() }),
                               between: startDate, and: endDate, then: process)
                }
            case .failure:
                process([])
            }
        }
    }
    
    private let manager = PHImageManager.default()
    private let blockedQueue = DispatchQueue(label: "imageCollectorQ", qos: .userInitiated)
    private let concurrentQueue = DispatchQueue(label: "imageAddingQ", qos: .userInteractive, attributes: .concurrent)
    
    private func image(matching keyPhrases: Set<String>,
                       between startDate: Date,
                       and endDate: Date,
                       then process: @escaping ImageHandler) {
        print(keyPhrases)
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@",
                                             startDate as NSDate, endDate as NSDate)
        
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        guard assets.count > 0 else { return process([]) }
        
        // let semaphore = DispatchSemaphore.init(value: 1 - assets.count)
        let group = DispatchGroup()
        var images = [ImageSuggestion]()
        let imagesLock = NSLock()
        
        for i in 0..<assets.count {
            group.enter()
            let asset = assets.object(at: i)
            // asset.localIdentifier
            manager.requestImageDataAndOrientation(for: asset, options: .allowNetworkAccess)
            { [unowned self] (data, string, orientation, info) in
                guard let data = data else {
                    group.leave()
                    return
                }
                
                let uiImage = UIImage(data: data)!
                
                if let assetRecord = ImageTagMemory[asset] {
                    self.addImage(uiImage, if: assetRecord.tags, in: keyPhrases,
                                  group: group, imagesLock: imagesLock, images: &images)
                    return
                }
                
                let jpegData = uiImage.jpegData(compressionQuality: 0.75)!
                
                ComputerVision.tag(image: jpegData, removeDuplicateTags: {
                    return Set($0.lazy.map { $0.lowercased() })
                }) { [unowned self] (result) in
                    switch result {
                    case .success(let (tags, description)):
                        self.concurrentQueue.async { [unowned self] in
                            ImageTagMemory[asset] = (tags, description)
                            self.addImage(uiImage, if: tags, in: keyPhrases,
                                          group: group, imagesLock: imagesLock, images: &images)
                        }
                    case .failure:
                        group.leave()
                    }
                }
            }
        }
        group.wait()
        process(images)
    }
    
    private func addImage(_ uiImage: UIImage, if tags: Set<String>, in keyPhrases: Set<String>,
                          group: DispatchGroup, imagesLock: NSLock, images: inout [ImageSuggestion]) {
        defer { group.leave() }
        
        if keyPhrases.intersection(tags).isEmpty {
            return
        }
        
        imagesLock.lock()
        images.append((uiImage, description))
        imagesLock.unlock()
    }
}

extension PHImageRequestOptions {
    fileprivate static let allowNetworkAccess: PHImageRequestOptions = {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isNetworkAccessAllowed = true
        return requestOptions
    }()
}

extension ImageSuggestionProvider: PHPhotoLibraryChangeObserver {
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        // MARK: TODO: handle changes
    }
}
