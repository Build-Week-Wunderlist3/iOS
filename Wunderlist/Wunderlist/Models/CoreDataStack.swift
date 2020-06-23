//
//  CoreDataStack.swift
//  Wunderlist
//
//  Created by Bohdan Tkachenko on 6/18/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
   lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Wunderlist")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
