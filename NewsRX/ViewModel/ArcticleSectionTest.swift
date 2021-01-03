//
//  ArcticleSectionTest.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 17.12.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import Foundation
import RxDataSources


struct ArticlesSectionTest {
    var header: String
    var articles: [Article]
}

extension ArticlesSectionTest: AnimatableSectionModelType {
    var items: [Article] { return articles }
    
    var identity : String { return UUID().uuidString }
    
    init(original: ArticlesSectionTest, items: [Article]) {
        self = original
        self.articles = items
    }
}
