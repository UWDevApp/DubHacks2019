//
//  Azure.swift
//  Feel Better
//
//  Created by Apollo Zhu on 10/12/19.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import Foundation
import NaturalLanguage

public enum TextAnalzyer {
    private static let key = "3f05fff4011c45c8aa4daee1af3579d7"
    private static let endpoint = "https://feel-better-text-analytics.cognitiveservices.azure.com/"
    
    private struct Request: Codable {
        let documents: [Document]
        struct Document: Codable {
            let id: Int
            let language: String
            let text: String
        }
    }
    
    private struct Response<Document: Codable>: Codable {
        let documents: [Document]
    }
    
    /// Analyzes the given piece of text.
    ///
    ///     TextAnalzyer.analyzeSentiment(of: "I'm very happy today") { (result) in
    ///         switch result {
    ///         case .success(let sentiment):
    ///             process(sentiment.score)
    ///         case .failure(let error):
    ///             print(error)
    ///     }
    ///
    /// - Parameters:
    ///   - text: string to be analyzed.
    ///   - process: process result
    public static func analyzeSentiment(of text: String,
                                        then process: @escaping (Result<SentimentAnalyzer.Result, Error>) -> Void) {
        let url = URL(string: endpoint + "text/analytics/v3.0-preview/sentiment")! //[?showStats]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.httpBody = try! JSONEncoder().encode(Request(documents: [.init(
            id: 1, language: language(of: text), text: text
        )]))
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let data = data else { return process(.failure(error!)) }
            process(Result {
                try JSONDecoder().decode(Response<SentimentAnalyzer.Result>.self, from: data).documents.first!
            })
        }).resume()
    }
    
    public static func language(of text: String) -> String {
        if let identifier = NLLanguageRecognizer.dominantLanguage(for: text)?.rawValue {
            return identifier
        }
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        let language = recognizer.dominantLanguage
            ?? recognizer.languageHypotheses(withMaximum: 1).first?.key
            ?? NLLanguage.english
        return language.rawValue
    }
}

extension TextAnalzyer {
    public struct SentimentAnalyzer {
        public struct Result: Codable {
            public enum Category: String, Codable {
                case positive
                case neutral
                case negative
                /// At document level only
                case mixed
            }
            private struct Scores: Codable {
                let positive: Double
                let neutral: Double
                let negative: Double
                
                var mixed: Int {
                    return Int((positive - negative + 1) * 50)
                }
            }
            public struct Sentence: Codable {
                public let sentiment: Category
                private let sentenceScores: Scores
                public let offset: Int
                public let length: Int
                
                /// A value between 0 and 100.
                public var score: Int {
                    return sentenceScores.mixed
                }
                
                public func score(forCategory category: Category) -> Double {
                    switch category {
                    case .positive:
                        return sentenceScores.positive
                    case .neutral:
                        return sentenceScores.neutral
                    case .negative:
                        return sentenceScores.negative
                    case .mixed:
                        return Double(score) / 100
                    }
                }
            }
            
            public let sentiment: Category
            private let documentScores: Scores
            public let sentences: [Sentence]
            
            /// A value between 0 and 100.
            public var score: Int {
                return Int(Double(sentences.reduce(0) { $0 + $1.score }) / Double(sentences.count))
            }
         
            public func score(forCategory category: Category) -> Double {
                switch category {
                case .positive:
                    return documentScores.positive
                case .neutral:
                    return documentScores.neutral
                case .negative:
                    return documentScores.negative
                case .mixed:
                    return Double(score) / 100
                }
            }
        }
    }
}
