//
//  TextAnalyzer.swift
//  Feel Better
//
//  Created by Apollo Zhu on 10/12/19.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import Foundation
import NaturalLanguage

public enum TextAnalzyer {
    public typealias Result<T> = Swift.Result<T, Error>
    
    public static func keyPhrases(in text: String,
                                  then process: @escaping (Result<[String]>) -> Void) {
        request("text/analytics/v2.1/keyPhrases", on: text)
        { (result: Result<KeyPhrases>) in process(result.map { $0.keyPhrases }) }
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
                                        then process: @escaping (Result<SentimentAnalysisResult>) -> Void) {
        request("text/analytics/v3.0-preview/sentiment", on: text, process: process)
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
