//
//  Router.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 05.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    
    case getArticles (page: Int)
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var url = try URLcostants.baseUrl.asURL()
        url = url
            .appendingPathComponent(version)
            .appendingPathComponent(path)
            .appendQueryItems(parameters)
            .appendQueryItems([URLcostants.Parameters.apiKey: URLcostants.apiKey])
        
        var urlRequest = URLRequest(url: url)
        
        // Http method
        urlRequest.httpMethod = httpMethod.rawValue
        
        // Common Headers
        urlRequest.setValue(
            URLcostants.ContentType.json.rawValue,
            forHTTPHeaderField: URLcostants.HttpHeaderField.acceptType.rawValue
        )
        
        
        // Encoding
        let encoding: ParameterEncoding = {
            switch httpMethod {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    //MARK: - HttpMethod
    private var httpMethod: HTTPMethod {
        switch self {
        case .getArticles:
            return .get
        }
    }
    
    //MARK: - Version
    private var version: String {
        switch self {
        case .getArticles:
            return URLcostants.version
        }
    }
    
    //MARK: - Path
    private var path: String {
        switch self {
        case .getArticles:
            return URLcostants.NewsMethods.everything.rawValue
        }
    }
    
    //MARK: - Parameters

    private var parameters: [String: String] {
        switch self {
        case .getArticles (let page):
                return [
                    URLcostants.Parameters.page: String(page),
                    URLcostants.Parameters.sources: URLcostants.Sources.crypto.rawValue
                ]
        }
    }
}

