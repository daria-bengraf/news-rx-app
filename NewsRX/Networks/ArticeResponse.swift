//
//  ArticeResponse.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 06.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import ObjectMapper


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
