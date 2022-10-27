//
//  Firebase Database Manager.swift
//  Messenger
//
//  Created by Kaan Turan on 7.09.2022.
//

import Foundation
import FirebaseDatabase
import MessageKit

final class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
}
// MARK: - Insert User Funcs / Get Users
extension DatabaseManager {
    public enum UserStatus {
        case alreadyIn
        case error
        case success
    }
    
    func insertUser(with user: ChatAppUser, completionBlock: @escaping (UserStatus) -> Void) {
        self.database.child("users").observeSingleEvent(of: .value) { snapshot, _  in
            if var userColletions = snapshot.value as? [[String: String]?] {
                let newElement = [
                    "name": user.userName,
                    "email": user.mailForFirebase]
                
                guard !userColletions.contains(newElement) else{
                    completionBlock(.alreadyIn)
                    return
                }
                userColletions.append(newElement)
                self.database.child("users").setValue(userColletions) { error, _ in
                    guard error == nil else {return}
                    completionBlock(.success)
                }
            } else {
                completionBlock(.error)
            }
            
        }
    }
    
    func getAllUsers(completition: @escaping (Result <[[String: String]],Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let users = snapshot.value as? [[String: String]?]  else{
                completition(.failure(DatabaseErrors.failedFetchUsers))
                return}
            let ozHakikiUsers:[[String: String]] = users.compactMap{ $0 }
            completition(.success(ozHakikiUsers))
        }
    }
    
    func getUserName(with email: String) async -> String {
        var userName: String?
        let (snapshot, _) = await self.database.child("users").observeSingleEventAndPreviousSiblingKey(of: .value)
        if let userColletions = snapshot.value as? [[String: String]?] {
            for element in userColletions {
                if element?["email"] == email {
                    userName = element?["name"] ?? "no found a user"
                    return userName!
                }
            }
        }
        return userName ?? "Error Username"
    }
    func getCurrentUserName(completion: @escaping (String) -> Void) {
        var currentUserName: String?
          database.child("users").observeSingleEvent(of: .value) { snapshot in
            if let userColletions = snapshot.value as? [[String: String]?] {
                for element in userColletions {
                    if element?["email"] == AuthManager.currentUser?.mailForFirebase {
                        currentUserName = element?["name"] ?? "no found a user"
                        completion(currentUserName ?? "There is an error about showing username")
                    }
                }
            }
        }
    }
}
// MARK: - Sending messages / Conversations
extension DatabaseManager {
    public func sendMessage(to otherUserEmail: String, message: Message /*completionBlock: @escaping (Bool) -> Void*/) {
        let conversationID = self.createConversationID(otherUserMail: otherUserEmail)
        checkConversationExist(with: conversationID) { [weak self] result in
            guard let self = self else {return}
            if result {
                self.saveMessage(conversationID: conversationID, message: message)
            } else {
                Task {
                    await self.createConversation(to: otherUserEmail) {
                        self.saveMessage(conversationID: conversationID, message: message)
                    }
                }
            }
        }
    }
    private func saveMessage(conversationID: String, message: Message) {
        let referance = database.child("conversations").child(conversationID).child("messages")
        referance.observeSingleEvent(of: .value) { snapshot in
            let date = message.sentDate.formatted(date: .complete, time: .shortened)
            let message: [String: Any] = [
                "messageId": message.messageId,
                "kind": message.kind.messageKindString,
                "sender": message.sender.getDicValue(),
                "isRead": message.isRead,
                "sendDate": date
            ]
            if var messageNode = snapshot.value as? [[String: Any]] {
                messageNode.append(message)
                referance.setValue(messageNode)
            }
            else {
                referance.setValue([message]) { _, _ in
                    
                }
            }
            
        }
        
    }
    
    private func createConversation(to otherUserMail: String, completionBlock: @escaping () -> Void) async {
        guard let email = AuthManager.currentUser?.mailForFirebase else {return}
        let otherUserName = await self.getUserName(with: otherUserMail)
        let currentUserName = AuthManager.userInfos.userName
        let referance =  database.child("conversations")
        referance.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var conversationsNode = snapshot.value as? [String: Any],
                  let self = self else { return }
            let conversationID = self.createConversationID(otherUserMail: otherUserMail)
            let newConversation: [String: Any] = [
                "id": conversationID,
                "users": [otherUserMail: otherUserName , email: currentUserName ],
                "messages": []
            ]
            conversationsNode[conversationID] = newConversation
            referance.setValue(conversationsNode) { error, dbreference in
                guard error == nil else{ return }
                completionBlock()
            }
        }
    }
    func createConversationID(otherUserMail: String) -> String {
        guard let email = AuthManager.currentUser?.mailForFirebase else {return "nil"}
        let prefix = "conversationID_"
        let conversationID = [email, otherUserMail].sorted().joined(separator: "_")
        return prefix + conversationID
    }
    
    private func checkConversationExist(with ID: String, completion: @escaping (Bool) -> Void) {
        let referance =  database.child("conversations")
        referance.observeSingleEvent(of: .value){ snapshot in
            guard let val = snapshot.value as? [String: Any]
            else {
                completion(false)
                return }
            let result = val.contains { $0.key == ID }
            completion(result)
        }
    }
    
    /// Fetching and returrns all conversations for current user
    public func getAllConversations(for email: String, completionBlock: @escaping (Result<[Conversation], Error>) -> Void) {
        let referance =  database.child("conversations")
        // referance.queryOrderedByKey().queryOrdered(byChild: "users").isEqual()
        referance.observe(.value) { [weak self] snapshot, _ in
            guard let val = snapshot.value as? [String: Any],
                  let self = self
            else {
                completionBlock(.failure(DatabaseErrors.failedFetchUsers))
                return
            }
            
            let filteredConversations = self.filteredconversations(with: val)
            let ourConversations = filteredConversations.map { val in
                Conversation(dictionary: val.value as! [String: Any])
            }
            completionBlock(.success(ourConversations))
        }
        
    }
    
    /// Get all conversations for current user.
    private func filteredconversations(with elements: [String : Any]) -> [String:Any] {
        guard let email = AuthManager.currentUser?.mailForFirebase else{ return ["error": 000]}
        var conversationlist = [String: Any]()
        for (key, value) in elements {
            if key.contains("\(email)") {
                conversationlist[key] = value as? [String: Any]
            }
        }
        return conversationlist
    }
    /// Fetching and returrns all conversations between target user and current user
    public func getAllMessages(for conversation: Conversation, completionBlock: @escaping (Result<[Message], Error>) -> Void ) {
        let referance =  database.child("conversations").child(conversation.id).child("messages")
        referance.observe(.value) { snapshot, _ in
            guard let val = snapshot.value as? [[String: Any]]
            else {
                completionBlock(.failure(DatabaseErrors.failedFetchMessages))
                return
            }
            let messages = val.map { val in
                Message(dictionary: val)
            }
            completionBlock(.success(messages))
        }
    }
    
}

// MARK: - Custom errors
public enum DatabaseErrors: Error {
    case failedFetchUsers
    case failedFetchMessages
}
