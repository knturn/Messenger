//
//  MessageModel.swift
//  Messenger
//
//  Created by Kaan Turan on 26.09.2022.
//

import Foundation
import MessageKit
    struct Message: MessageType {
        var sender: SenderType
        var messageId: String
        var sentDate: Date
        var kind: MessageKind
        var isRead: Bool

        init(dictionary: [String: Any]) {
            let senderDic = dictionary["sender"] as? [String: String] ?? ["a" : "a"]
            sender = Sender(dictionary: senderDic)
            messageId = dictionary["messageId"] as? String ?? "a"
            sentDate = dictionary["sentDate"] as? Date ?? Date()
            kind = MessageKind.text(dictionary["kind"] as? String ?? "aaak")
            isRead = dictionary["isRead"] as? Bool ?? false
        }
        init(sender: SenderType, messageId: String, sentDate: Date, kind: MessageKind, isRead: Bool) {
            self.sender = sender
            self.messageId = messageId
            self.sentDate = sentDate
            self.kind = kind
            self.isRead = isRead
        }
    }
extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(let content):
            return content
        case .attributedText(_):
            return "attributedText"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "linkPreview"
        case .custom(_):
            return "custom"
        }
    }
}
struct Sender: SenderType, Codable {
        var senderId: String
        var displayName: String
        init(dictionary: [String: Any]) {
            self.senderId = dictionary["senderId"] as? String ?? ""
            self.displayName = dictionary["displayName"] as? String ?? ""
        }
        init(senderId: String, displayName: String) {
            self.senderId = senderId
            self.displayName = displayName
        }
    
    }

extension SenderType {
    func getDicValue() -> [String: Any] {
        let dic = ["senderId": senderId, "displayName": displayName]
        return dic
    }
}
extension Sender {
    static var selfSender: Sender {
        let email = AuthManager.currentUser?.mailForFirebase ?? "kimsin"
        let userName = AuthManager.userInfos.userName ?? ""
        return Sender(senderId: email, displayName: userName )
    }
}





