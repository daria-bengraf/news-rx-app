//
//  ArticlesResponse.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 06.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import Foundation


import Foundation
import AlamofireObjectMapper
import ObjectMapper


class ArticlesResponse: Mappable {
    var articles: [ArticleResponse]?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        articles <- map["articles"]
    }
}


class ArticleResponse: Mappable {
    var title: String?
    var author: String?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        title <- map["title"]
        author <- map["author"]
    }
}
