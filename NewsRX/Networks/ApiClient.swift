//
//  ApiClient.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 05.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//



import Alamofire
import RxSwift
import ObjectMapper

class ApiClient {
    
    static public func getPosts(page: Int ) -> Observable<Articles?> {
        return self.request(ApiRouter.getArticles(page: page))
    }
    
    private static func extract<T: Mappable>(type: T.Type, data: Any) -> T? {
        guard let json = data as? [String : Any] else { return nil }
        let model = T(JSON: json)
        return model
    }
    
    private static func request<T: Mappable> (_ urlConvertible: URLRequestConvertible) -> Observable<T?> {
        return Observable<T?>.create { observer in
            
            let request = Alamofire
                .request(urlConvertible)
                .responseJSON{ response  in
                    switch response.result {
                    case .success(let responseData):
                        
                        let model = self.extract(type: T.self, data: responseData)
                        
                        observer.onNext(model)
                        observer.onCompleted()
                    case .failure(let error):
                        switch response.response?.statusCode {
                        case 403:
                            observer.onError(ApiError.forbidden)
                        case 404:
                            observer.onError(ApiError.notFound)
                        case 409:
                            observer.onError(ApiError.conflict)
                        case 500:
                            observer.onError(ApiError.internalServerError)
                        default:
                            observer.onError(error)
                        }
                    }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
