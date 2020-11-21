//
//  URL+Extensions.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 03.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import Foundation

extension URL {
    func appendQueryItems(_ queryItemsDistionary: Dictionary<String, String>) -> URL {

        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        queryItemsDistionary.forEach { (key: String, value: String) in
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }
        
        urlComponents.queryItems = queryItems

        return urlComponents.url!
    }
}
