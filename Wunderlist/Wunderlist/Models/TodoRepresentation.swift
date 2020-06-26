//
//  TodoRepresentation.swift
//  Wunderlist
//
//  Created by Bohdan Tkachenko on 6/23/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import Foundation

struct TodoRepresentation: Codable {
    let title: String
    let identifier: String
    let complete: Bool
    let notes: String?
    let reminderTime: Date
    
}
