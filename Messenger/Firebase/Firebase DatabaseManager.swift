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
    
    func insertUser(with user: ChatAppUser) {
        database.child(user.mailForFirebase).setValue(["username:" : user.userName])
    }

    
    
}
