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
    
    var articlesVM : Observable<[ArticlesSectionTest]> = Observable.empty()
    var apiService: PublishSubject<Void> = PublishSubject()
    var coreDataService: PublishSubject<Void> = PublishSubject()
    var pageNum : Int = 0
    let countPerPage: Int = 20
    
    let disposeBag = DisposeBag()
    
    init () {
        articlesVM = setupCoredataService()
        setupApiService()
    }
    
    public func loadMore() -> Void {
        self.apiService.onNext(())
    }
    
    private func setupCoredataService() -> Observable<[ArticlesSectionTest]> {
        return self.coreDataService
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { Article.fetch() }
            .do(onNext: { [weak self] articles in
                guard let self = self else { return }
                
                if !articles.isEmpty {
                    self.pageNum = articles.count / self.countPerPage
                } else {
                    self.pageNum = 0
                    self.loadMore()
                }
            })
            .map {(articles: [Article]) in
                    return [ArticlesSectionTest(header: "_", articles: articles)]
                }}
        
    
        
        
    private func setupApiService() -> Void {
        self.apiService
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            
            self.pageNum += 1
            
            ApiClient
                .getPosts(page: self.pageNum)
                .subscribe(onNext: { articlesModel in
                    CoreDataStack.instance.saveContext()
                    self.coreDataService.onNext(())
                })
                .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
    }
    
}

