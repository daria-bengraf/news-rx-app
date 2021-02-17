//
//  NewsList.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 01.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData
import SnapKit

class NewsListController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, NSFetchedResultsControllerDelegate  {
    
    let disposeBag = DisposeBag()
    
    private let reuseIdentifier = "Cell"
    private var articlesViewModel = ArticlesViewModel()
    private var articleImageLoader = ArticleImageLoader()

    var mainScrollView: UIScrollView = {
        let mainScrollView = UIScrollView()
        mainScrollView.backgroundColor = .black
        mainScrollView.isScrollEnabled = true
        
        return mainScrollView
    }()
    
    
    // MARK: - FRC
    private lazy var fetchedResultsController: NSFetchedResultsController<Article> = {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        
        let nameSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataStack.instance.managedContext,
            sectionNameKeyPath: "id",
            cacheName: nil
        )
        frc.delegate = self
        return frc
    }()
    
    
    // MARK: - Fetched Results Controller Delegate -
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .bottom)
        default: return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let section = IndexSet(integer: sectionIndex)
        
        switch type {
        case .delete:
            tableView.deleteSections(section, with: .automatic)
        case .insert:
            tableView.insertSections(section, with: .bottom)
        default: break
            
        }
    }
    
    // MARK: - TableViewDatasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)as? NewsCell else {
            fatalError("Wrong cell type dequeued")
        }
        let article = fetchedResultsController.object(at: indexPath)
        
        cell.descriptionLabel.text = article.title
        cell.articleLabel.text = article.text
        cell.publishedAt.text = article.publishedAt?.toString()
                
        if (article.image != nil) {
            cell.newsImageView.image = UIImage(data: article.image!)
        } else {
            DispatchQueue.global(qos: .background).async {
                self.articleImageLoader.load(article: article)
            }
        }
        
        return cell
    }
    
    let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = true
        return tableView;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(NewsCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.dataSource = self
        self.mainScrollView.delegate = self
        self.tableView.delegate = self
        setupViews()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Core Data fetch error")
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceToBottom = scrollView.contentSize.height - contentYoffset - height
        
        if (distanceToBottom < height) && !articlesViewModel.isLoading {
            let currentCount = fetchedResultsController.fetchedObjects?.count ?? 0
            articlesViewModel.pageNum = currentCount / articlesViewModel.countPerPage
            articlesViewModel.apiService.onNext(())
        }
    }
    
//    private func reloadTableView(){
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
    
    
    private func setupViews() {
        navigationItem.title = "Crypto News"
        view.addSubview(mainScrollView)
        view.addSubview(tableView)
        addConstraints()
        
        updateLayout(with: self.view.frame.size)
    }
    
    private func updateLayout(with size: CGSize) {
        tableView.frame = CGRect.init(origin: .zero, size: size)
    }
    
    private func addConstraints () {
        
        mainScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
