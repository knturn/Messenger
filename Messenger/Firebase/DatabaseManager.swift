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
    
    func insertUser(with user: ChatAppUser, completionBlock: @escaping (Bool) -> Void) {
        database.child(user.mailForFirebase).setValue(["username:" : user.userName]) { error, _ in
            guard error == nil else {
                print("failed to create user")
                completionBlock(false)
                return
            }
            completionBlock(true)
            
        }
    }

    
    
}
