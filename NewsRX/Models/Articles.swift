//
//  Articles.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 03.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData
import RxDataSources

class Articles: Mappable{
    var articles: [Article] = []
    
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        articles <- map["articles"]
    }
}

@objc(Article)
final class Article: NSManagedObject {
    
    @NSManaged public var uuid: UUID
    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var image: Data?
    
    @nonobjc static func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }
    
    static func fetch() -> [Article] {
        do {
            return try CoreDataStack.instance.managedContext.fetch(fetchRequest())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    static func fetchOne(uuid: UUID) -> Article? {
        do {
            let request: NSFetchRequest<Article> = fetchRequest()
            request.predicate = NSPredicate(format: "uuid == %@", uuid.uuidString.lowercased())
            return try CoreDataStack.instance.managedContext.fetch(request).first
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
}

extension Article: Mappable, Identifiable {
    public convenience init?(map: Map) {
        let context = CoreDataStack.instance.managedContext
        let entity = NSEntityDescription.entity(forEntityName: "Article", in: context)

        self.init(entity: entity!, insertInto: context)
        self.uuid = UUID()
    }
    
    public func mapping(map: Map) {
        title <- map["title"]
        text <- map["description"]
        urlToImage <- map["urlToImage"]
    }
}


extension Article: IdentifiableType {
    public var identity: String { return UUID.init().uuidString }
}


    
    
