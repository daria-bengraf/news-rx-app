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
    
    public  func fetch<T: NSManagedObject>(_ fetchRequest: NSFetchRequest<T>, ofType _: T.Type, async: Bool = true, completion: @escaping (Result<[T], Error>) -> ()) {
        
        if async {
            
            let asyncFetchRequest = NSAsynchronousFetchRequest<T>(fetchRequest: fetchRequest) { (result: NSAsynchronousFetchResult) in
                
                guard let finalResult = result.finalResult else {
                    self.handle(CoreDataStackError.noFinalResult) {
                        completion(.failure(CoreDataStackError.noFinalResult))
                    }
                    return
                }
                completion(.success(finalResult))
            }
            
            do {
                try managedContext.execute(asyncFetchRequest)
            } catch let error as NSError {
                handle(error) {
                    completion(.failure(error))
                }
            }
            
        } else {
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                completion(.success(result))
            } catch let error as NSError {
                handle(error) {
                    completion(.failure(error))
                }
            }
            
        }
    }
    
    public func fetch<T: NSManagedObject>(entityName: String, ofType _: T.Type, async: Bool = true, completion: @escaping (Result<[T], Error>) -> ()) {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetch(fetchRequest, ofType: T.self, async: async, completion: completion)
    }
    
    public func fetch<T: NSManagedObject>(requestName: String, ofType _: T.Type, async: Bool = true, completion: @escaping (Result<[T], Error>) -> ()) {
        guard let fetchRequest = managedContext.persistentStoreCoordinator?.managedObjectModel.fetchRequestTemplate(forName: requestName) as? NSFetchRequest<T> else {
            self.handle(CoreDataStackError.noFetchRequest) {
                completion(.failure(CoreDataStackError.noFetchRequest))
            }
            return
        }
        fetch(fetchRequest, ofType: T.self, async: async, completion: completion)
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
