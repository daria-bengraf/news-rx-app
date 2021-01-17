//
//  CoreDataObservable.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 07.01.2021.
//  Copyright © 2021 Dariya Bengraf. All rights reserved.
//

import CoreData
import Foundation
import RxCocoa
import RxSwift

class CoreDataObservable<T>: NSObject, ObservableType, NSFetchedResultsControllerDelegate where T: NSManagedObject {
    
    private var fetchedResultsController: NSFetchedResultsController<NSManagedObject>?
    private let context: NSManagedObjectContext
    private let fetchRequest: NSFetchRequest<T>
    private let results = BehaviorSubject<[T]>(value: [])
    
    // Observable element type definition - generic NSManagedObect
    typealias Element = [T]
    
    init(fetchRequest: NSFetchRequest<T>, context: NSManagedObjectContext) {
        if fetchRequest.sortDescriptors == nil {
            fetchRequest.sortDescriptors = []
        }
        
        self.fetchRequest = fetchRequest
        self.context = context
        super.init()
    }
    
    func count() -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func subscribe<Observer>(_ observer: Observer) -> Disposable
        where Observer: ObserverType, CoreDataObservable.Element == Observer.Element {
            let frc = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            frc.delegate = self
            
            do {
                try frc.performFetch()
                let result = frc.fetchedObjects ?? []
                results.onNext(result)
            } catch {
                print("Could not fetch objects: \(error)")
            }
            fetchedResultsController = frc as? NSFetchedResultsController<NSManagedObject>
            
            return FetcherDisposable(fetcher: self, observer: observer)
    }
    
    // Попытка перехватывать изменения в fetchedObjects, чтобы в контролеер добавлять секцию с изменениями
    // Но это выглядит как-то глупо и не работает :)
    //
    //    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith diff: CollectionDifference<NSManagedObjectID>) {
    //        var insertedObjects: [T] = []
    //        for change in diff {
    //            switch change {
    //                case let .insert(offset, _, associatedWith):
    //                    if let _ = associatedWith {
    //                        break
    //                    } else {
    //                        print("INSERT", offset)
    //                        guard let managedObject = fetchedResultsController?.fetchedObjects?[offset] else { break }
    //                        insertedObjects.append(
    //                            managedObject as! T
    //                        )
    //                        results.onNext(insertedObjects)
    //                    }
    //                case .remove( _, _, _): break
    //            }
    //        }
    //
    //    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let result = controller.fetchedObjects as? [T] ?? []
        results.onNext(result)
    }
    
    private func dropSubscription() {
        fetchedResultsController?.delegate = nil
        fetchedResultsController = nil
    }
    
    private class FetcherDisposable: Disposable {
        var fetcher: CoreDataObservable?
        var disposable: Disposable?
        
        init<Observer>(
            fetcher: CoreDataObservable,
            observer: Observer
        ) where Observer: ObserverType, CoreDataObservable.Element == Observer.Element {
            self.fetcher = fetcher
            
            self.disposable = fetcher.results.subscribe(
                onNext: { observer.onNext($0) },
                onError: { observer.onError($0) },
                onCompleted: { observer.onCompleted() },
                onDisposed: {}
            )
        }
        
        func dispose() {
            disposable?.dispose()
            disposable = nil
            fetcher?.dropSubscription()
            fetcher = nil
        }
    }
}
