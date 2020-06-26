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
        fetchTodosFromServer()
    }
    
    func fetchTodosFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error fetching todos with: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from Firebase (Fetching todos)")
                completion(.failure(.noData))
                return
            }
            
            do {
                let todoRepresentation = Array(try JSONDecoder().decode([String: TodoRepresentation].self, from: data).values)
                try self.updateTodos(with: todoRepresentation)
            } catch {
                NSLog("Error decoding todo from Firebase: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
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
        let reminderTimeToFetch = representations.compactMap { $0.reminderTime }
        let representationByTime = Dictionary(uniqueKeysWithValues: zip(reminderTimeToFetch, representations))
        var todoToCreate = representationByTime
        
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "reminderTime IN %@", reminderTimeToFetch)
        
        let context = CoreDataStack.shared.mainContext
        
            let existingTodos = try context.fetch(fetchRequest)
            
            for todo in existingTodos {
                guard let time = todo.reminderTime,
                    let representation = representationByTime[time] else { continue }
                self.update(todo: todo, with: representation)
                todoToCreate.removeValue(forKey: time)
            }
            
            for representation in todoToCreate.values {
                Todo(todoRepresenation: representation, context: context)
            }
            
            try context.save()

    }
    
    private func update(todo: Todo, with representation: TodoRepresentation) {
        todo.title = representation.title
        todo.notes = representation.notes
        todo.complete = representation.complete
        todo.reminderTime = representation.reminderTime
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
}
