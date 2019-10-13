//
//  SentimentAnalyzer.swift
//  Feel Better
//
//  Created by Apollo Zhu on 10/12/19.
//  Copyright © 2019 Feel Better. All rights reserved.
//

extension TextAnalzyer {
    public struct SentimentAnalysisResult: Codable {
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
