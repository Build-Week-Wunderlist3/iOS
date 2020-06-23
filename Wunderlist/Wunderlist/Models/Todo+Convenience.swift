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
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
          let theDate = dateFormatter.string(from: date)
        
        return TodoRepresentation(title: title, identifier: id.uuidString, complete: complete, notes: notes, reminderTime: theDate)
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
        let dateFormatter = DateFormatter()
              dateFormatter.dateStyle = .medium
              dateFormatter.timeStyle = .medium
        let theDate = dateFormatter.date(from: todoRepresenation.reminderTime)
        
        self.init(identifier: uuid, title: todoRepresenation.title, notes: todoRepresenation.notes, complete: todoRepresenation.complete, reminderTime: theDate ?? Date(), context: context)
    }
    
    
    
}
