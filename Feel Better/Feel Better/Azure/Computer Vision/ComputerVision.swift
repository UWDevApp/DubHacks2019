//
//  ComputerVision.swift
//  Feel Better
//
//  Created by Apollo Zhu on 10/12/19.
//  Copyright © 2019 Feel Better. All rights reserved.
//

//
//  ComputerVision.swift
//  Feel Better
//
//  Created by Apollo Zhu on 10/12/19.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import Foundation

public enum ComputerVision {
    private static let key = "7ea07789bb9d45ed8dd6f80faf933707"
    private static let endpoint = "https://feel-better-computer-vision.cognitiveservices.azure.com/"
    
    public static func tag(
        image: Data, removeDuplicateTags: @escaping ([String]) -> Set<String>,
        then process: @escaping (Result<ImageTagMemory.ImageTag, Error>) -> Void
    ) {
        let query = "/vision/v2.0/analyze?"
            + "visualFeatures=Brands,Categories,Description,Tags"
            + "&details=Celebrities,Landmarks"
        // [&language]
        let url = URL(string: endpoint + query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.addValue(key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.httpBody = image
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let data = data else { return process(.failure(error!)) }
            print(String(data: data, encoding: .utf8)!)
            process(Result {
                try JSONDecoder().decode(ImageAnalysisResult.self, from: data)
            }.map { result in
                let detailTags = result.categories
                    .compactMap { $0.detail }
                    .flatMap { (detail) -> [String] in
                        let allCelebrities = detail.celebrities?.allNames(withConfidence: 0.5) ?? []
                        let allLandmarks = detail.landmarks?.allNames(withConfidence: 0.5) ?? []
                        return allCelebrities + allLandmarks
                }
                let descriptionTags = result.description.tags
                let tagTags = result.tags.allNames(withConfidence: 0.5)
                let brandTags = result.brands.map { $0.name }
                return (removeDuplicateTags(detailTags + descriptionTags + tagTags + brandTags),
                        result.description.captions.first?.text)
            })
        }).resume()
    }
}

public struct NamedMLResult: Codable {
    let name: String
    /// 0...1
    let confidence: Double
}

extension Array where Element == NamedMLResult {
    func allNames(withConfidence minConfidence: Double) -> [String] {
        return filter { $0.confidence > minConfidence }.map { $0.name }
    }
}

public struct ImageAnalysisResult: Codable {
    public let categories: [Category]
    public struct Category: Codable {
        /// very cryptic
        private let name: String
        /// 0...1
        public let score: Double
        public let detail: Detail?
        public struct Detail: Codable {
            /// In the actual celebrities data structure:
            ///     public let faceRectangle: FaceRectangle
            public let celebrities: [NamedMLResult]?
            public let landmarks: [NamedMLResult]?
        }
    }
    // public let adult: Classification
    // public struct Classification: Codable {
    //     public let isAdultContent: Double
    //     public let isRacyContent: Double
    //     public let adultScore: Double
    //     public let racyScore: Double
    // }
    public let tags: [NamedMLResult]
    
    public let description: Description
    public struct Description: Codable {
        public let tags: [String]
        public let captions: [Caption]
        public struct Caption: Codable {
            public let text: String
            public let confidence: Double
        }
    }
    
    // let requestId: String
    // let metadata: Metadata
    // public struct Metadata: Codable {
    //     let width: Int
    //     let height: Int
    //     let format": String
    // }
    
    // public let faces: [Face]
    // public struct Face: Codable {
    //     public let age: Int
    //     public let gender: String
    //     public let faceRectangle: FaceRectangle
    // }
    
    // public let color: Color
    // public struct Color: Codable {
    //     // named color possible
    //     public let dominantColorForeground: String
    //     public let dominantColorBackground: String
    //     public let dominantColors: [String]
    //     // hex string
    //     public let accentColor: String
    //     public let isBWImg: Bool
    // }
    
    // public let imageType: ImageType
    // public struct ImageType: Codable {
    //     public let clipArtType: Int
    //     public let lineDrawingType: Int
    // }
    
    public let brands: [Brand]
    public struct Brand: Codable {
        public let name: String
        public let rectangle: Rectangle
        public struct Rectangle: Codable {
            public let x: Int
            public let y: Int
            public let w: Int
            public let h: Int
        }
    }
}
