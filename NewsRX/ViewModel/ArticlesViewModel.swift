//
//  ArticleViewModel.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 02.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class ArticlesViewModel {
    
    var apiService: PublishSubject<Void> = PublishSubject()
    var pageNum : Int = 0
    let countPerPage: Int = 20
    let disposeBag = DisposeBag()
    
    init () {
        self.apiService
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                
                self.pageNum += 1
                print ("Load page \(self.pageNum)")
                ApiClient
                    .getPosts(page: self.pageNum)
                    .subscribe(onNext: { articlesModel in
                        CoreDataStack.instance.saveContext()
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
    func withPage(n: Int) -> ArticlesViewModel {
        pageNum = n
        return self
    }
}

