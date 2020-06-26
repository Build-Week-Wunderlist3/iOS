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
    //convert from todo
    var todoRepresentation: TodoRepresentation? {
        guard let id = identifier,
            let title = title,
            let date = reminderTime else { return nil }
        
        return TodoRepresentation(title: title, identifier: id.uuidString, complete: complete, notes: notes, reminderTime: date)
    }
    
    //create new managed object
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
    
    //convert into todo
    @discardableResult convenience init?(todoRepresenation: TodoRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let uuid = UUID(uuidString: todoRepresenation.identifier) else { return nil }
        self.init(identifier: uuid, title: todoRepresenation.title, notes: todoRepresenation.notes, complete: todoRepresenation.complete, reminderTime: todoRepresenation.reminderTime, context: context)
    }
    
    
    
}
