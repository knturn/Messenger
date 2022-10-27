//
//  NewConversationsModel.swift
//  Messenger
//
//  Created by Kaan Turan on 26.09.2022.
//

import Foundation

final class NewConversationViewModel {
    private var users = [[String: String]]()
    private var results = [[String: String]]()
    var isFetched = false
    func getUsers(query: String, completion: @escaping (Bool) -> Void) {
        guard !isFetched else {
            filteredUsers(with: query)
            completion(true)
            return
        }
        DatabaseManager.shared.getAllUsers { [weak self] result in
            switch result {
            case .success(let value):
                self?.isFetched = true
                self?.users = value
                self?.filteredUsers(with: query)
                completion(true)
            case .failure(let error):
                print("Failed fetch users: \(error)")
                completion(false)
            }
        }
        
    }
     private func filteredUsers(with term: String) {
            results = users.filter {
                guard let name = $0["name"]?.lowercased(),
                          name != AuthManager.userInfos.userName
                else{return false}
                return name.hasPrefix(term.lowercased())
        }
    }
    
    
    func goToChatPage(with target: [String: String],
                      completion: @escaping (Conversation) -> Void) {
            guard let name = target["name"],
                  let email = target["email"] else {return}
    
        let conv = Conversation(dictionary: [ "id": DatabaseManager.shared.createConversationID(otherUserMail: email),
                                              "users": [email: name , AuthManager.currentUser?.mailForFirebase: "Kaan" ],
                                              "messages": []])
        completion(conv)
        
    }
    func resultCount() -> Int {
        results.count
    }
    func searchedUser(by: Int) -> [String: String] {
        results[by]
    }
    func resultsName (by: Int) -> String? {
        results[by]["name"]
    }
}
