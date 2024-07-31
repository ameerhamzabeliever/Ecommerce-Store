//
//  PersistenceStorage.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 22/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation
import CoreData

final class PersistenceStorage {
    
    private init() {}
    
    static let shared = PersistenceStorage()
    
    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "pisiffik_ios")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchResultOf<T: NSManagedObject>(type: T.Type) -> [T]?{
        do{
            guard let result = try PersistenceStorage.shared.context.fetch(type.fetchRequest()) as? [T] else {return nil}
            return result
        }catch let error as NSError{
            print(error.localizedDescription)
            return nil
        }
    }
    
}
