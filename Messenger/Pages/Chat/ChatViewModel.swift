//
//  ChatViewModel.swift
//  Messenger
//
//  Created by Kaan Turan on 21.09.2022.
//

import Foundation
import MessageKit


final class ChatViewModel {
    public static var dateFormatter: DateFormatter = {
        let frmtter = DateFormatter()
        frmtter.dateStyle = .full
        frmtter.timeStyle = .long
        frmtter.locale = .current
        return frmtter
    }()
    var messages = [Message]()
    func sendMessage(to conv: Conversation, content: String) {
        let userMails = conv.users.keys
        if let otherUserEmail = userMails.filter({ $0 != AuthManager.currentUser?.mailForFirebase}).first{
            let message = createMessage(with: content, otherUserMail: otherUserEmail )
            DatabaseManager.shared.sendMessage(to: otherUserEmail, message: message)
        }
        else {
            print("errooor")
        }
        
    }
    private func createMessage(with content: String, otherUserMail: String) -> Message {
        let messageId = createMessageID(with: otherUserMail)
        let message = Message(sender: Sender.selfSender, messageId: messageId, sentDate: Date(), kind: .text(content), isRead: false)
        return message
    }
    func createMessageID(with otherUserEmail: String) -> String {
        // date, otherUsermail, randomINT
        guard let currentUserEmail = AuthManager.currentUser?.email
        else { return "Empty mail /error"}
        let dateString = String(Date().timeIntervalSince1970)
        let newIdentifier = "\(otherUserEmail)_\(currentUserEmail)_\(dateString)"
        return newIdentifier
    }
    
    func getMessages(conv: Conversation, comletion: @escaping (Bool)->Void) {
        DatabaseManager.shared.getAllMessages(for: conv) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let val):
                self.messages = val
                comletion(true)
            case .failure(let failure):
                comletion(false)
                print(failure)
            }
        }
    }
    func getMessageForRow(int: Int) -> Message {
        return messages[int]
    }
    
    func getProfilePicture(message: MessageType, completion: @escaping (URL) -> Void) {
        let sender = message.sender
        if sender.senderId == Sender.selfSender.senderId {
            guard let url = AuthManager.userInfos.currentUserProfilePictureUrl
            else {
                print("Error happend while fetching current user picture url")
                return
            }
            
            completion(url)
            
        }
        else {
            guard !ChatListCell.urlArray.keys.contains(message.sender.senderId)
            else{
                if let url = ChatListCell.urlArray[message.sender.senderId] {
                    completion(url)
                }
                return}
            
            let otherUserEmail = sender.senderId
            let path = otherUserEmail.getProfileImagePath()
            StorageManager.shared.downloadURL(for: path) { result in
                switch result {
                case .success(let url):
                    completion(url)
                case .failure(_):
                    print("Error happend while showing other profile picture")
                }
            }
        }
    }
    
}



