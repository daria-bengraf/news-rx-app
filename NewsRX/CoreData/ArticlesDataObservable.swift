//
//  ArticlesDataObservable.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 07.01.2021.
//  Copyright © 2021 Dariya Bengraf. All rights reserved.
//

import Foundation
import CoreData

class ArticlesDataObservable: CoreDataObservable<Article> {
    private let entityName = "Article"
    
    init(context: NSManagedObjectContext) {
        let request: NSFetchRequest<Article> = NSFetchRequest<Article>(entityName: entityName)
        request.sortDescriptors = []
        
        super.init(fetchRequest: request, context: context)
    }
}
