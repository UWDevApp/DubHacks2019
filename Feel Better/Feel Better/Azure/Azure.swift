//
//  Azure.swift
//  Feel Better
//
//  Created by Apollo Zhu on 10/12/19.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import Foundation

extension TextAnalzyer {
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
    
    internal static func request<Content: Codable>(_ path: String, on text: String,
                                                   process: @escaping (Result<Content>) -> Void) {
        let url = URL(string: endpoint + path)!
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
                try JSONDecoder().decode(Response<Content>.self, from: data).documents.first!
            })
        }).resume()
    }
}

private enum ComputerVision {
    private static let key = "7ea07789bb9d45ed8dd6f80faf933707"
    private static let endpoint = "https://feel-better-computer-vision.cognitiveservices.azure.com/"
}
