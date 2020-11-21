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
            
            let request = Alamofire
                .request(url)
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
    }
}
