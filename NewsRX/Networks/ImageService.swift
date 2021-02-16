//
//  ArticleImageLoader.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 14.02.2021.
//  Copyright © 2021 Dariya Bengraf. All rights reserved.
//

import Foundation
import Alamofire

class ArticleImageLoader {
    private lazy var AFManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCredentialStorage = nil
        configuration.timeoutIntervalForRequest = 100
        configuration.httpMaximumConnectionsPerHost = 10
        
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    public func load (article: Article) -> Void {
        guard let imageUrlString = article.urlToImage else { return }
        guard let url = URL(string: imageUrlString) else { return }
        AFManager
            .request(url)
            .responseData{ response  in
                switch response.result {
                case .success(let responseData):
                    DispatchQueue.global(qos: .background).async {
                        article.image = responseData
                        CoreDataStack.instance.saveContext()
                    }
                case .failure(_):
                    print("Image load failure...")
                }
        }
    }
}
