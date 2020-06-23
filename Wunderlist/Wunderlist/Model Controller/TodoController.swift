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



class TodoController {
    
    let baseURL = URL(string: "https://wunderlist-675bd.firebaseio.com/")!
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    init() {
        
    }
    
    func fetchTodosFromServer(completion: @escaping CompletionHandler = { _ in }) {
        
    }
    
    func sendTodosToServer(todo: Todo, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = todo.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard let represenation  = todo.todoRepresentation else {
                completion(.failure(.noEncode))
                return
            }
            request.httpBody = try JSONEncoder().encode(represenation)
        } catch {
            NSLog("Error encoding todo: \(todo), \(error)")
            completion(.failure(.noEncode))
            return
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error sending todo to server \(todo), \(error)")
                completion(.failure(.otherError))
                return
            } 
            completion(.success(true))
        }.resume()
    }
    
     private func updateTodos(with representations: [TodoRepresentation]) throws {
        
    }
    
    private func update(todo: Todo, with representation: TodoRepresentation) {
        
    }
    
     func deleteTaskFromServer(_ todo: Todo, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = todo.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error deleting todo from server \(todo), \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }.resume()
    }
    
     private func saveToPersistentStore() throws {
        
    }
    
}
