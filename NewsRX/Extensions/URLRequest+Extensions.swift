//
//  URLRequest+Extensions.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 22.10.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

//import Foundation
//import RxCocoa
//import RxSwift
//
//struct Resouce<T:Decodable> {
//    let url: URL
//}
//
//extension URLRequest {
//    static func load <T>(resource:Resouce <T>) -> Observable <T> {
//
//        return Observable
//            .just(resource.url)
//            .flatMap { url -> Observable<Data> in
//                let request = URLRequest(url: url)
//                return URLSession.shared.rx.data(request: request)
//            }
//            .map { data -> T in
//                return try JSONDecoder().decode(T.self, from: data)
//            }
//    }
//}
