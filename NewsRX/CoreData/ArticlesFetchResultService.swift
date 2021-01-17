//
//  ArticlesFetchResultService.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 05.01.2021.
//  Copyright © 2021 Dariya Bengraf. All rights reserved.
//

import Foundation
import CoreData

class ArticlesFetchResultService {
    
    public var fetchResultController: NSFetchedResultsController<Article>?
    private let entityName = "Article"
    private let context: NSManagedObjectContext;
    
    static var instance: ArticlesFetchResultService = {
        return ArticlesFetchResultService(context: CoreDataStack.instance.managedContext)
    }()
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let sortByTitle = NSSortDescriptor(key: "title", ascending: true)
        let request: NSFetchRequest<Article> = NSFetchRequest<Article>(entityName: entityName)
        request.sortDescriptors = [sortByTitle]
        
        fetchResultController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        do {
            guard let fetchResultController = fetchResultController else {
                throw NSError(domain: "Can't build fetch controller", code: 100, userInfo: nil)
            }
            try fetchResultController.performFetch()
        } catch let error as NSError {
            print("Could not run perform. \(error)")
        }
        
    }
    
}
