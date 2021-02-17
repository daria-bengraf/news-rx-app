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
    
    @NSManaged public var id: Int64
    @NSManaged public var uuid: UUID
    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var image: Data?
    @NSManaged public var author: String?
    @NSManaged public var publishedAt: Date?
    
    @nonobjc static func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }
}

extension Article: Mappable, Identifiable {
    public convenience init?(map: Map) {
        //let context = CoreDataStack.instance.managedContext
        let context = CoreDataStack.instance.childManagedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "Article", in: context)

        self.init(entity: entity!, insertInto: context)
        self.uuid = UUID()
        self.id = Date().millisecondsSince1970
    }
    
    public func mapping(map: Map) {
        title <- map["title"]
        text <- map["description"]
        urlToImage <- map["urlToImage"]
        author <- map["author"]
                
        if let publishedAtString = map["publishedAt"].currentValue as? String {
            publishedAt = publishedAtString.toDate(withFormat: "yyyy-MM-DD'T'HH:mm:ss'Z'")
        }
    }
}


extension Article: IdentifiableType {
    public var identity: String { return UUID.init().uuidString }
}


    
    
