//
//  FetchResultService.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 05.01.2021.
//  Copyright © 2021 Dariya Bengraf. All rights reserved.
//

import Foundation
import CoreData

class FetchResultService {
    let context: NSManagedObjectContext;
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}
