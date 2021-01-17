//
//  ArticlesSection.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 02.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import Foundation


struct ArticlesSection {
 var articleViewModels = [ArticleViewModel]()
    
init(articleModels: [Article]) {
        
   articleViewModels = articleModels.compactMap { (article: Article) in
           return ArticleViewModel(article)
}
 }
}


