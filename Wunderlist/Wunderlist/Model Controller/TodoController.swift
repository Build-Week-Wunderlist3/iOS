//
//  TodoController.swift
//  Wunderlist
//
//  Created by Bohdan Tkachenko on 6/23/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

let baseURL = URL(string: "https://tasks-3f211.firebaseio.com/")!


