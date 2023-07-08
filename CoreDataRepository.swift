//
//  PersistenceController.swift
//  mindScribe
//
//  Created by user on 2023/06/11.
//

import Foundation
import CoreData

// Repofetch data and save data
class CoreDataRepository {
    static let shared = CoreDataRepository()
    
    private let container = NSPersistentContainer(name: "DiaryEntryModel")

    private init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func newEntity<T: NSManagedObject>() -> T {
        return T(context: container.viewContext)
    }
    
    func fetch<T: NSFetchRequestResult>() -> Array<T> {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))
        
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func save<T: NSManagedObject>(item: T) {
        container.viewContext.insert(item)
        
        do {
            try container.viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func delete<T: NSManagedObject>(item: T) {
           container.viewContext.delete(item)
           
           do {
               try container.viewContext.save()
           } catch let error as NSError {
               print("Could not delete. \(error), \(error.userInfo)")
           }
       }

}
