//
//  CoreDataStack.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 03.11.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//


import Foundation
import CoreData

public class CoreDataStack {
    
    private let modelName: String
    private let usesFatalError: Bool
    
    static var instance: CoreDataStack = {
        return CoreDataStack(modelName: "NewsRX")
    }()
    
    init(modelName: String,  usesFatalError: Bool = false) {
        self.modelName = modelName
        self.usesFatalError = usesFatalError
    }
    
    public lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    public lazy var childManagedObjectContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = managedContext
        return context
    }()
    
    private lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            self.handle(error)
        }
        return container
        
    }()
    
    public func saveContext(completion: @escaping (Result<Bool, Error>) -> () = {_ in}) {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
            completion(.success(true))
        } catch {
            handle(error) {
                completion(.failure(error))
            }
        }
    }
    
    
    public func saveBackground(completion: @escaping (Result<Bool, Error>) -> () = {_ in}) {
        guard childManagedObjectContext.hasChanges else { return }
        childManagedObjectContext.perform {
            
            do {
                try self.childManagedObjectContext.save()
                self.managedContext.performAndWait {
                    do {
                        try self.managedContext.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
        
    }
    
    
    
    private func handle(_ error: Error?, completion: @escaping () -> () = {}) {
        if let error = error as NSError? {
            let message = "CoreDataStack -> \(#function): Unresolved error: \(error), \(error.userInfo)"
            if usesFatalError {
                fatalError(message)
            } else {
                print(message)
            }
            completion()
        }
    }
}

struct CoreDataStackError {
    static let noFetchRequest = NSError(domain: "No Fetch Request", code: 1, userInfo: nil)
    static let noFinalResult = NSError(domain: "No Final Result", code: 1, userInfo: nil)
}
