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
import RxDataSources
class NewsListController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate  {
    
    let disposeBag = DisposeBag()
    
    private let reuseIdentifier = "Cell"
    private var articlesViewModel = ArticlesViewModel()
    private var articlesSections  = [ArticlesSection]()
    private var isLoading = false
    
    
    var mainScrollView: UIScrollView = {
        let mainScrollView = UIScrollView()
        mainScrollView.backgroundColor = .black
        mainScrollView.isScrollEnabled = true
        
        return mainScrollView
    }()
    
    
    let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = true
        return tableView;
    }()
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return articlesSections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesSections[section].articleViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? NewsCell else { fatalError("no cell")}
        let section = self.articlesSections[indexPath.section]
        let articleVM = section.articleViewModels[indexPath.row]
        
        articleVM.title.asDriver(onErrorJustReturn:"")
            .drive(cell.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        articleVM.text.asDriver(onErrorJustReturn:"")
            .drive(cell.articleLabel.rx.text)
            .disposed(by: disposeBag)
       
        articleVM.image.asDriver(onErrorJustReturn: UIImage())
            .drive(cell.newsImageView.rx.image)
            .disposed(by: disposeBag)
                
        return cell
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.tableView.register(NewsCell.self, forCellReuseIdentifier: reuseIdentifier)
//        self.tableView.dataSource = self
//        self.mainScrollView.delegate = self
//        self.tableView.delegate = self
//        setupViews()
//
//        articlesViewModel
//            .articlesVM
//            .observeOn(MainScheduler.instance)
//            .bind(onNext: { (articlesSections: [ArticlesSectionTest]) -> Void in
//                self.articlesSections = articlesSections
//                self.reloadTableView()
//                self.isLoading = false
//            })
//            .disposed(by: disposeBag)
//
//        articlesViewModel.coreDataService.onNext(())
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceToBottom = scrollView.contentSize.height - contentYoffset - height
        
        if (distanceToBottom < height) && !isLoading {
            isLoading = true
            self.articlesViewModel.apiService.onNext(())
        }
    }
    
    private func reloadTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    private func setupViews() {
        self.navigationItem.title = "Crypto News"
        view.addSubview(mainScrollView)
        view.addSubview(tableView)
        addConstraints ()
        
        self.updateLayout(with: self.view.frame.size)
    }
    
    private func updateLayout(with size: CGSize) {
       self.tableView.frame = CGRect.init(origin: .zero, size: size)
    }
    
    private func addConstraints () {
        //mainScrollView.translatesAutoresizingMaskIntoConstraints = false
       // mainScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
       // mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
       // mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      //  mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        mainScrollView.snp.makeConstraints { make in
            make.top.trailing.leading.bottom.equalToSuperview()
        }
        
        //tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        //tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
       // tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
}
