//
//  Firebase Database Manager.swift
//  Messenger
//
//  Created by Kaan Turan on 7.09.2022.
//

import Foundation
import FirebaseDatabase


final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}
// MARK: - Insert User Funcs / Get Users
extension DatabaseManager {
    func insertUser(with user: ChatAppUser, completionBlock: @escaping (Bool) -> Void) {
        database.child(user.mailForFirebase).setValue(["username" : user.userName]) { error, _ in
            guard error == nil else {
                print("failed to create user")
                completionBlock(false)
                return
            }
            self.database.child("users").observeSingleEvent(of: .value) { snapshot in
                if var userColletions = snapshot.value as? [[String: String]] {
                    let newElement = [
                        "name": user.userName,
                        "email": user.mailForFirebase]
                    
                    let cnt = userColletions.contains(["name" : user.userName,
                                                       "email" : user.mailForFirebase])
                    if !cnt {
                        userColletions.append(newElement)
                    }
                    
                    self.database.child("users").setValue(userColletions) { error, _ in
                        guard error == nil else{
                            completionBlock(false)
                            return
                        }
                        completionBlock(true)
                    }
                }
                else {
                    let newCollection: [[String: String]] = [
                        [
                            "name" : user.userName,
                            "email" : user.mailForFirebase
                        ]
                    ]
                    self.database.child("users").setValue(newCollection) { error, _ in
                        guard error == nil else{
                            completionBlock(false)
                            return
                        }
                        completionBlock(true)
                    }
                }
            }
        }
    }
    
    func getAllUsers(completition: @escaping (Result <[[String: String]],Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let users = snapshot.value as? [[String: String]]  else{
                completition(.failure(DatabaseErrors.failedFetchUsers))
                return}
            completition(.success(users))
            
            
        }
    }
}
// MARK: - Sending messages / Conversaitons
extension DatabaseManager {
    /// Create a new conversation with target user email. Also send first message
    public func createNewConversaiton(with otherUserMail: String, firstMessage: Message , completionBlock: @escaping (Bool) -> Void) {
        
    }
    /// Fetching and returrns all conversations for current user
    public func getAllConversations(for email: String, completionBlock: @escaping (Result<String, Error>) -> Void) {
    }
    /// Fetching and returrns all conversations between target user and current user
    public func getAllMessages(with id: String, completionBlock: @escaping (Result<String, Error>) -> Void ) {
        
    }
    /// Send a message with target conversaiton and message
    public func sendMessage(to conversation: String, message: Message, completionBlock: @escaping (Bool) -> Void) {
        
    }
}

// MARK: - Custom errors
public enum DatabaseErrors: Error {
    case failedFetchUsers
}
