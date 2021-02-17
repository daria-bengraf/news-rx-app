//
//  URLconstants.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 05.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import Foundation

struct URLcostants {
    
    static let baseUrl = "https://newsapi.org"
    static let version = "v2"
    
    static var apiKey: String {
      get {
        guard let filePath = Bundle.main.path(forResource: "NA", ofType: "plist") else {
          fatalError("Couldn't find file 'NA.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "APIKey") as? String else {
          fatalError("Couldn't find key 'APIKey' in 'NA.plist'.")
        }
        return value
      }
    }
    
    enum NewsMethods: String {
        case topHeadlines = "top-headlines"
        case everything = "everything"
    }
    
    struct Parameters {
        static let country = "country"
        static let q = "q"
        static let sources = "sources"
        static let page = "page"
        static let apiKey = "apiKey"
    }
    
    enum HttpHeaderField: String {
        case authorization = "Authorization"
        case acceptType = "Accept"
        case cacheControl = "Cache-Control"
        case acceptEncoding = "Accept-Encoding"
        case contentType = "Content-Type"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
    
    enum Sources: String {
        case crypto = "cnn"
    }
}

