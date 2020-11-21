//
//  ArticleCoreDataModel+CoreDataProperties.swift
//  
//
//  Created by Dariya Bengraf on 09.11.2020.
//
//

import Foundation
import CoreData


extension ArticleCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleCoreDataModel> {
        return NSFetchRequest<ArticleCoreDataModel>(entityName: "ArticleCoreDataModel")
    }

    @NSManaged public var title: String?
    @NSManaged public var descriptions: String?

}
