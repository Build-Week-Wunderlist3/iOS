//
//  Todo+Convenience.swift
//  Wunderlist
//
//  Created by Bohdan Tkachenko on 6/19/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import Foundation
import CoreData

extension Todo {
   @discardableResult convenience init(identifier: UUID = UUID(),
                     title: String,
                     notes: String? = nil,
                     complete: Bool = false,
                     reminderTime: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.notes = notes
        self.complete = complete
        self.reminderTime = reminderTime
        
    }
    
    
    
    
    
    
}
