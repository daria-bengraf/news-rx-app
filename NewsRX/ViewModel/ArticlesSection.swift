//
//  ArticlesSection.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 10.01.2021.
//  Copyright © 2021 Dariya Bengraf. All rights reserved.
//

import Foundation
import RxDataSources


struct ArticleSection {
    var header: String
    var articles: [Article]
}

extension ArticleSection: AnimatableSectionModelType {
    var items: [Article] { return articles }
    
    var identity : String { return UUID().uuidString }
    
    init(original: ArticleSection, items: [Article]) {
        self = original
        self.articles = items
    }
}


extension ArticleSection: Hashable {
    
}
