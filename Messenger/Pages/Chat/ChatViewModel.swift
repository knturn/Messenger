//
//  ChatViewModel.swift
//  Messenger
//
//  Created by Kaan Turan on 21.09.2022.
//

import Foundation


 final class ChatViewModel {
     var messages = [Message]()
     func createNewConversations(with message: Message, completionBlock: @escaping (_ success: Bool) -> Void) {
         DatabaseManager.shared.createNewConversaiton(with: "", firstMessage: message) { success in
             completionBlock(success)
         }
     }
     func sendMessage(with message: Message, completionBlock: @escaping (_ success: Bool) -> Void) {
         DatabaseManager.shared.sendMessage(to: "cafer", message: message) { succcess in
            completionBlock(succcess)
         }
     }
     func createMessageID(with otherUserEmail: String) -> String {
         // date, otherUsermail, randomINT
         guard let currentUserEmail = AuthManager.currentUser?.email else { return "Empty"}
          let newIdentifier = "\(otherUserEmail)_\(currentUserEmail)"
         return newIdentifier
     }
}



