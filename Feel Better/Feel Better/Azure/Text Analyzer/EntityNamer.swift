//
//  EntityNamer.swift
//  Feel Better
//
//  Created by Apollo Zhu on 10/12/19.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import Foundation

extension TextAnalzyer {
    public struct Entity: Codable {
        public let name: String
        public let wikipediaUrl: URL?
        private let type: String?
        private let subType: String?
        public let matches: [MatchResult]
        
        public struct MatchResult: Codable {
            // let wikipediaScore: Double
            // let entityTypeScore: Double
            let text: String
            let offset: Int
            let length: Int
        }
        
        public enum Category {
            /// "Jeff", "Bill Gates"
            case person //
            /// "Redmond, Washington", "Paris"
            case location // Location
            /// "Microsoft"
            case organization // Organization
            /// Some kind of quantity
            case quantity(QuantityCategory) // Quantity
            public enum QuantityCategory {
                /// "6", "six"
                case number // Number
                /// "50%", "fifty percent"
                case percentage // Percentage
                /// "2nd", "second"
                case ordinal // Ordinal
                /// "90 day old", "30 years old"
                case age // Age
                /// "$10.99"
                case currency // Currency
                /// "10 miles", "40 cm"
                case dimension // Dimension
                /// "32 degrees"
                case temperature // Temperature
            }
            /// Some kind of date time
            case dateTime(DateTimeCategory) // DateTime
            public enum DateTimeCategory {
                /// "6:30PM February 4, 2012"
                case generic // null
                /// "May 2nd, 2017", "05/02/2017"
                case date // Date
                /// "8am", "8:00"
                case time // Time
                /// "May 2nd to May 5th"
                case dateRange // DateRange
                /// "6pm to 7pm"
                case timeRange // TimeRange
                /// "1 minute and 45 seconds"
                case duration // Duration
                /// "every Tuesday"
                case set // Set
            }
            /// "https://www.bing.com"
            case url // URL
            /// "support@contoso.com"
            case email // Email
            
            /// The "other" type
            case hasLinkOnWikipedia
        }
        
        public var category: Category {
            switch type {
            case "Person": return .person
            case "Location": return .location
            case "Organization": return .organization
            case "Quantity":
                switch subType {
                case "Number": return .quantity(.number)
                case "Percentage": return .quantity(.percentage)
                case "Ordinal": return .quantity(.ordinal)
                case "Age": return .quantity(.age)
                case "Currency": return .quantity(.currency)
                case "Dimension": return .quantity(.dimension)
                case "Temperature": return .quantity(.temperature)
                default: return .hasLinkOnWikipedia
                }
            case "DateTime":
                switch subType {
                case nil: return .dateTime(.generic)
                case "Date": return .dateTime(.date)
                case "Time": return .dateTime(.time)
                case "DateRange": return .dateTime(.dateRange)
                case "TimeRange": return .dateTime(.timeRange)
                case "Duration": return .dateTime(.duration)
                case "Set": return .dateTime(.set)
                default: return .hasLinkOnWikipedia
                }
            case "URL": return .url
            case "Email": return .email
            default: return .hasLinkOnWikipedia
            }
        }
        
        internal struct Wrapper: Codable {
            let entities: [Entity]
        }
    }
}
