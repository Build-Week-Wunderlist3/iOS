//
//  Authentication￼Controller.swift
//  Wunderlist
//
//  Created by Bohdan Tkachenko on 6/23/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let token: String
}

struct User: Codable {
    let username: String
    let password: String
}

final class AuthenticaticationController {
    
    enum HTTPMethod: String {
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case noData, failedSignUp, failedSignIn, noToken
    }
    
    private let baseURL = URL(string: "https://wunderlist3.herokuapp.com/api")!
    private lazy var registerURL = baseURL.appendingPathComponent("/auth/register")
    private lazy var loginURL = baseURL.appendingPathComponent("/auth/login")
    var bearer: Bearer?
    
    //Register the user
    
    func register(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = URLRequest(url: registerURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print(user)
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { (_, response, error) in
                if let error = error {
                    NSLog("SignUp failer with error: \(error)")
                    completion(.failure(.failedSignUp))
                    return
                }
                print(response)
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        NSLog("Register user was unsuccessful")
                        completion(.failure(.failedSignUp))
                        return
                }
                completion(.success(true))
            }.resume()
            
        } catch {
            NSLog("Error encoding user: \(error)")
            completion(.failure(.failedSignUp))
        }
    }
    
    // SignIn User
    func signIn(with user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    NSLog("SignIn failer with error: \(error)")
                    completion(.failure(.failedSignIn))
                    return
                }
                print(response)
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        NSLog("SignIn was unsuccessful")
                        completion(.failure(.failedSignIn))
                        return
                }
                guard let data = data else {
                    NSLog("data was not recieved")
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    self.bearer = try decoder.decode(Bearer.self, from: data)
                    completion(.success(true))
                    print(self.bearer)
                } catch {
                    NSLog("Error decoding with \(error)")
                    completion(.failure(.noToken))
                }
            }.resume()
        } catch {
            NSLog("Etrror encoding user: \(error)")
            completion(.failure(.failedSignIn))
        }
        
        
    }
    
    
    
    
    
    
    
    
}
