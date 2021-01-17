//
//  UIScrollView+Extensions.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 03.01.2021.
//  Copyright © 2021 Dariya Bengraf. All rights reserved.
//

import Foundation
import RxSwift


extension Reactive where Base: UIScrollView {
    public var lazyLoadNeeded: Observable<Void> {
        let scrollView = self.base as UIScrollView

        return self.contentOffset
            .throttle(
                .seconds(4),
                scheduler: MainScheduler.instance
            )
            .flatMap { [weak scrollView] (contentOffset) -> Observable<Void> in
                guard let scrollView = scrollView else { return Observable.empty() }
            
                let height = scrollView.frame.size.height
                let contentYoffset = scrollView.contentOffset.y
                let distanceToBottom = scrollView.contentSize.height - contentYoffset - height
                
                return (distanceToBottom < height) ? Observable.just(()) : Observable.empty();
            }
    }
}
