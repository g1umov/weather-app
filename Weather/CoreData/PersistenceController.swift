//
//  PersistenceController.swift
//  Weather
//
//  Created by Vladislav on 30.10.22.
//

import CoreData

final class PersistenceController {
    private let persistenceContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistenceContainer.viewContext
    }
    
    init(modelName: String) {
        persistenceContainer = NSPersistentContainer(name: modelName)
        persistenceContainer.loadPersistentStores { (_, error) in
            if let _error = error {
                fatalError("Unable to load Core Data stack, \(_error)")
            }
        }
    }
}
