//
//  ImageService.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 19.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import Alamofire
import RxSwift
import Foundation


class ImageService {
    
    public func load (url: URL) -> Observable<Data> {
        return Observable<Data>.create { observer in
            // Попытка излечить ошибку HTTP load failed, 0/0 bytes (error code: -999 [1:89])
            let configuration = URLSessionConfiguration.default
            configuration.urlCredentialStorage = nil
            configuration.timeoutIntervalForRequest = 100
            configuration.httpMaximumConnectionsPerHost = 10
            
            let manager = Alamofire.SessionManager(configuration: configuration)
            let request = manager
                .request(url)
                .validate()
                .responseData{ response  in
                    switch response.result {
                    case .success(let responseData):
                        observer.onNext(responseData)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
        .observeOn(MainScheduler.instance)
    }
}
