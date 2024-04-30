//
//  UserManager.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 30/04/2024.
//

import CoreData
import CryptoKit
import SwiftUI

class UserManager {
    
    static let shared = UserManager()
    
    private init() {}
    
    func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func registerUser(
        email: String,
        firstName: String,
        secondName: String,
        phoneNumber: String,
        password: String,
        context: NSManagedObjectContext,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        let hashedPassword = hashPassword(password)
        let newUser = User(context: context)
        newUser.email = email
        newUser.firstName = firstName
        newUser.secondName = secondName
        newUser.phoneNumber = phoneNumber
        newUser.password = hashedPassword
        newUser.role = "user"
        
        do {
            try context.save()
            completion(.success(newUser))
        } catch {
            completion(.failure(error))
        }
    }
    
    func logIn(email: String, password: String, context: NSManagedObjectContext, appState: AppState, completion: @escaping (Bool) -> Void) {
        let hashedPassword = hashPassword(password)
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, hashedPassword)
        
        do {
            let results = try context.fetch(request)
            if let user = results.first {
                DispatchQueue.main.async {
                    appState.logIn(user: user)
                }
                completion(true)
            } else {
                completion(false)
            }
        } catch {
            print("Login error: \(error)")
            completion(false)
        }
    }
}