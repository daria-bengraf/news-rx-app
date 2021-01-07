//
//  NewsListTestController.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 15.12.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import CoreData
import RxDataSources
class NewsListTestController: UIViewController {
    
    let disposeBag = DisposeBag()
    private let reuseIdentifier = "Cell"
    private var articlesViewModel = ArticlesViewModel()
    private var dataSource: RxTableViewSectionedReloadDataSource<ArticlesSectionTest>!
    
    var mainScrollView: UIScrollView = {
        let mainScrollView = UIScrollView()
        mainScrollView.backgroundColor = .black
        mainScrollView.isScrollEnabled = true
        
        return mainScrollView
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(NewsCell.self, forCellReuseIdentifier: "Cell")
        tableView.isScrollEnabled = true
        return tableView;
    }()
    
    
    func bindToTable() {
        articlesViewModel.articlesVM
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.lazyLoadNeeded
            .bind(to: articlesViewModel.coreDataService)
            .disposed(by: disposeBag)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        dataSource = RxTableViewSectionedReloadDataSource<ArticlesSectionTest>(configureCell: { [weak self] dataSource, table, indexPath, article in
            guard let self = self else { return UITableViewCell() }
            guard let cell = table.dequeueReusableCell(withIdentifier: self.reuseIdentifier) as? NewsCell else { return UITableViewCell()}
            let articleVM = ArticleViewModel(article)
                        
            articleVM.title.asDriver(onErrorJustReturn:"")
                .drive(cell.descriptionLabel.rx.text)
                .disposed(by: self.disposeBag)
            
            articleVM.text.asDriver(onErrorJustReturn:"")
                .drive(cell.articleLabel.rx.text)
                .disposed(by: self.disposeBag)
            
            articleVM.image.asDriver(onErrorJustReturn: UIImage())
                .drive(cell.newsImageView.rx.image)
                .disposed(by: self.disposeBag)
        
            return cell
            
        })
        
        bindToTable()
        setupViews()
        
        articlesViewModel.coreDataService.onNext(())
    }
    
    
    func setupViews() {
        self.navigationItem.title = "Crypto News"
        view.addSubview(mainScrollView)
        view.addSubview(tableView)
        
        mainScrollView.snp.makeConstraints { make in
            make.top.trailing.leading.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
}
