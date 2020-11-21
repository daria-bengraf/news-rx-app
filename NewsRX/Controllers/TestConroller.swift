//
//  TestConroller.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 02.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ViewController: UIViewController {
    
    //Dispose bag
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        ApiClient.getPosts(page: 1)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { postsList in
                    print("List of posts:", postsList)
                    
                    let posts = postsList?.articles
                    
                    if let posts = posts {
                        for post in posts {
                            print(post.title)
                            print(post.text)
                        }
                    }
                    
                },
                onError: { error in
                    switch error {
                    case ApiError.conflict:
                        print("Conflict error")
                    case ApiError.forbidden:
                        print("Forbidden error")
                    case ApiError.notFound:
                        print("Not found error")
                    default:
                        print("Unknown error:", error)
                }
            })
            .disposed(by: disposeBag)
    }
}
