//
//  ArticleViewModel.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 02.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import RxSwift
import RxCocoa

class ArticleViewModel {
    
    let articleModel: Article
    let imagePublisher: PublishSubject<Void> = PublishSubject()
    var imageProvider: PublishSubject<Data?> = PublishSubject()
    
    let imageService: ImageService = ImageService()
    let disposeBag = DisposeBag()
    
    var image: Observable<UIImage?> = Observable.empty()
    
    init( _ articleModel: Article) {
        self.articleModel = articleModel
        self.setupImagePublisher()
        image = self.setupImageProvider()
        imageProvider.onNext(articleModel.image)
    }
    
    private func setupImageProvider() -> Observable<UIImage?> {
        let observableData =  self.imageProvider
            .do(onNext: { [weak self] (data: Data?) in
                guard let self = self else { return }
                
                if data == nil {
                    self.imagePublisher.onNext(())
                }
            })
                
        return observableData.map { (data: Data?) -> UIImage? in
            guard let data = data else { return UIImage(named: "Image") }
            return UIImage(data: data)
        }

    }
    
    func buildImage(data: Data?) -> UIImage? {
        guard let data = data else { return UIImage(named: "placeholder-image") }
        return UIImage(data: data)
    }
    
    func setupImagePublisher() -> Void {
        self.imagePublisher
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                guard let imageUrlString = self.articleModel.urlToImage else { return }
                guard let url = URL(string: imageUrlString) else { return }
                
                self.imageService
                    .load(url: url)
                    .observeOn(MainScheduler.instance)
                    .bind(onNext: { [weak self] (imageData: Data) -> Void in
                        guard let self = self else { return }
                        self.articleModel.image = imageData
                        CoreDataStack.instance.saveContext()
                        self.imageProvider.onNext(imageData)
                        
                    })
                    .disposed(by: self.disposeBag)
                
            })
            .disposed(by: disposeBag)
    }
    
    
    
    var title: Observable<String>{
        return Observable<String>.just(articleModel.title ?? "")
    }
    
    var text: Observable <String>{
        return Observable <String>.just(articleModel.text ?? "")
    }
    
    var urlToImage: Observable <String>{
        return Observable <String>.just(articleModel.urlToImage ?? "")
    }
}


