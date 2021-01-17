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
class NewsListController: UITableViewController {

    let disposeBag = DisposeBag()
    private let reuseIdentifier = "Cell"
    
    enum Section: Hashable {
        case items
    }
    
    private var dataSource: RxTableViewSectionedAnimatedDataSource<ArticleSection> {
        RxTableViewSectionedAnimatedDataSource<ArticleSection>(
            animationConfiguration: AnimationConfiguration(
                insertAnimation: .none,
                reloadAnimation: .none,
                deleteAnimation: .none
            ),
            configureCell: configureCell,
            canEditRowAtIndexPath: canEditRowAtIndexPath,
            canMoveRowAtIndexPath: canMoveRowAtIndexPath
        )}
    
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
    
    private var fetchedResultsController: NSFetchedResultsController<Article>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request: NSFetchRequest<Article> = NSFetchRequest<Article>(entityName: "Article")
        request.sortDescriptors = []
        
        // not shown: create the diffable data source
        fetchedResultsController
            = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: CoreDataStack.instance.managedContext,
                sectionNameKeyPath: nil,
                cacheName: nil
        )
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            updateSnapshot(animated: false)
        } catch {
            NSLog("Could not fetch to-do items: \(error)")
        }
    }
    
    private func updateSnapshot(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        snapshot.appendSections([.items])
        snapshot.appendItems(
            fetchedResultsController.fetchedObjects ?? [],
            toSection: .items
        )
        
        print(snapshot.itemIdentifiers)
    }
    
    
    func setupViews() {
        self.navigationItem.title = "Crypto News"
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
}


extension NewsListController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
    }
}
