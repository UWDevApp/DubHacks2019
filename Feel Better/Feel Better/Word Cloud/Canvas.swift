//
//  Canvas.swift
//  Feel Better
//
//  Created by Kevin Tong on 2019/10/12.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit

final class Canvas {

    let size: CGSize
    var items: [WordImage] = []

    private(set) lazy var currentImage: CGImage = {
        UIGraphicsBeginImageContext(size)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.cgImage!
    }()

    init(size: CGSize) {
        self.size = size
    }

    
    func add(word: Word) {
        let startPixel = CGPoint(x: Int.random(in: 0...Int(size.width - word.size.width)),
                                 y: Int.random(in: 0...Int(size.height - word.size.height)))

        let wordRepresentation = WordImage(point: startPixel, image: draw(word, at: startPixel), word: word)
        if intersected(word: wordRepresentation, image: currentImage) { return }
        currentImage = join(image: currentImage, word: wordRepresentation)
    }
}

// MARK: - Drawing
private extension Canvas {
    private func draw(_ word: Word, at point: CGPoint) -> CGImage {

        UIGraphicsBeginImageContext(word.size)

        
        (word.text as NSString).draw(at: .zero, withAttributes: word.attributes)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()

        return newImage!.cgImage!
    }

    private func join(image: CGImage, word: WordImage) -> CGImage {
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * Int(size.width)
        let bitsPerComponent = 8

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                                bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)!

        context.draw(image, in: CGRect(origin: .zero, size: size))
        context.draw(word.image, in: word.rect.reversedY(with: size))

        return context.makeImage()!
    }
}

// MARK: - Comparing
private extension Canvas {
    private func intersected(word: WordImage, image: CGImage) -> Bool {
        let wordPixels = pixels(from: word.image)
        let backgroundPixels = pixels(from: image)

        for y in (Int(word.point.y)..<Int(word.point.y) + word.image.height) {
            for x in (Int(word.point.x)..<Int(word.point.x) + word.image.width) {
                let imageOffset = (image.width * y + x) * 4
                let wordOffset = (word.image.width * (y - Int(word.point.y)) + (x - Int(word.point.x))) * 4

                let wordAlpha = wordPixels[wordOffset + 3]
                let backgroundAlpha = backgroundPixels[imageOffset + 3]

                if wordAlpha != 0 && backgroundAlpha != 0 {
                    return true
                }
            }
        }

        return false
    }
}

// MARK: - Bytes
extension Canvas {
    private func pixels(from image: CGImage) -> UnsafePointer<UInt8> {
        guard let pixelData = image.dataProvider?.data,
            let data = CFDataGetBytePtr(pixelData) else {
                fatalError()
        }
        return data
    }
}

