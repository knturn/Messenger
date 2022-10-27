//
//  ConversationsModel.swift
//  Messenger
//
//  Created by Kaan Turan on 6.10.2022.
//

import Foundation
struct Conversation {
    let id: String
    let messages: Message
    let users: [String: String]
    init(dictionary: [String: Any]) {
        let messageDic = dictionary["messages"] as? [[String: Any]]
        self.id = dictionary["id"] as? String ?? "nil"
        self.messages = Message(dictionary: messageDic?.last ?? ["error": 00])
        self.users = dictionary["users"] as? [String: String] ?? ["nil" : "00"]
    }
}


struct TestUser {
    let email: String = ""
    let name: String = ""
    let url: String = ""
    
    init(dic: [String: Any]) {
        
    }
    
    func getUserFromEmail() {
        
    }
}
