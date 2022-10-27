//
//  ChatPageViewModel.swift
//  Messenger
//
//  Created by Kaan Turan on 9.09.2022.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

final class ChatListViewModel {
    private var conversations = [Conversation]()
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        do  {
        try FirebaseAuth.Auth.auth().signOut()
        }
        catch {
            print("Can't sign out")
        }
    }
    func fetchConversations(complation: @escaping (Bool) -> Void) {
        guard let email = AuthManager.currentUser?.mailForFirebase else{return}
        DatabaseManager.shared.getAllConversations(for: email) { [weak self] result in
            switch result{
            case .success(let conversations):
                self?.conversations = conversations
                complation(true)
            case .failure(_):
                complation(false)
                print("error while fetching conversations")
            }
        }
    }
    func getUserName(for conv: Conversation) -> String {
        let array = conv.users.values
        guard let username = AuthManager.userInfos.userName else {return "No Name"}
        let otherUserName = array.drop { s in
            s == username
        }.first
        return otherUserName ?? "No Name"
    }
    func getConversation(int: Int) -> Conversation {
        conversations[int]
    }
    func conversationsLength() -> Int {
        conversations.count
    }
    func getconversationId(int: Int) -> String {
        conversations[int].id
    }
    func getOtherUserMail(int: Int) ->String{
        conversations[int].users.filter { $0.key != AuthManager.currentUser?.mailForFirebase}.first?.key ?? "there was an error"
        
    }
    
    
    
}
