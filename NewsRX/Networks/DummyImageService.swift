//
//  DummyImageService.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 06.01.2021.
//  Copyright © 2021 Dariya Bengraf. All rights reserved.
//

import Foundation
import Alamofire

class DummyImageService {
    
    public func load (url: URL) -> Data {
        // Попытка излечить ошибку HTTP load failed, 0/0 bytes (error code: -999 [1:89])
        let configuration = URLSessionConfiguration.default
        configuration.urlCredentialStorage = nil
        
        let manager = Alamofire.SessionManager(configuration: configuration)
        let request = manager
            .request(url)
            .responseData{ response  in
                switch response.result {
                case .success(let responseData):
                    return responseData
                case .failure(let error):
                    throw error                }
        }
    }
}
