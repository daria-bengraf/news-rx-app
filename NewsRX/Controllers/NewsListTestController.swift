//
//  NewsListController.swift
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
    private var sections: [ArticleSection] = []
    
    private var configureCell: RxTableViewSectionedAnimatedDataSource<ArticleSection>.ConfigureCell {
        return { [weak self] _, tableView, indexPath, article in
            guard let self = self else { return UITableViewCell() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier) as? NewsCell else { return UITableViewCell()}
            
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
        }
    }
    
    private var canEditRowAtIndexPath: RxTableViewSectionedAnimatedDataSource<ArticleSection>.CanEditRowAtIndexPath {
        return { [unowned self] _, _ in
            if self.tableView.isEditing {
                return true
            } else {
                return false
            }
        }
    }
    
    private var canMoveRowAtIndexPath: RxTableViewSectionedAnimatedDataSource<ArticleSection>.CanMoveRowAtIndexPath {
        return { _, _ in
            return true
        }
    }
    
    let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(NewsCell.self, forCellReuseIdentifier: "Cell")
        tableView.isScrollEnabled = true
        return tableView;
    }()
    
    
    func bindData() {
        let data = ArticlesDataObservable(context: CoreDataStack.instance.managedContext)
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<ArticleSection>(
            animationConfiguration: AnimationConfiguration(
                insertAnimation: .none,
                reloadAnimation: .none,
                deleteAnimation: .none
            ),
            configureCell: configureCell,
            canEditRowAtIndexPath: canEditRowAtIndexPath,
            canMoveRowAtIndexPath: canMoveRowAtIndexPath
        )
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        
        data
            .asDriver(onErrorJustReturn: [])
            .map{ [ArticleSection(header: String($0.count), articles: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        tableView.rx.lazyLoadNeeded
            .bind(to: articlesViewModel.withPage(n: data.count() / articlesViewModel.countPerPage).apiService)
            .disposed(by: disposeBag)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        setupViews()
    }
    
    
    func setupViews() {
        self.navigationItem.title = "Crypto News"
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
}
