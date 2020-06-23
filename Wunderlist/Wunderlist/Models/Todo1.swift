//
//  Todo.swift
//  Wunderlist
//
//  Created by Bohdan Tkachenko on 6/18/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import Foundation

// At some point model for the app
struct ToDo1 {
    let title: String //for sure
    let identifier: String //every new task has its own identifier.
    let complete: Bool = false //it can be completed
    let notes: String? //notes for the todo
    let reminderTime: Date? //reminder....could be sorted..using predicates??
    
}


//To Do
//add
//edit
//delete
//complete
//reminder
//set a date
//priority
