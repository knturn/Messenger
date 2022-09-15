//
//  UserModel.swift
//  Messenger
//
//  Created by Kaan Turan on 8.09.2022.
//

import Foundation

struct ChatAppUser {
    let userName: String
    let emailAdress: String
    
    var mailForFirebase: String {
        let mailForFirebase = emailAdress.replacingOccurrences(of: ".", with: "-")
        return mailForFirebase
    }
}
