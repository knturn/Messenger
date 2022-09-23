//
//  ChatViewController.swift
//  Messenger
//
//  Created by Kaan Turan on 15.09.2022.
//
import UIKit
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController  {
    private let selfSender = Sender(photoURL: "",
                                    senderId: "1",
                                    displayName: "Kaan Turan")
    
    private var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("We can do this. We can do this. We can do this. We can do this. We can do this. We can do this ")))
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("We can do this. Yes u can ")))
        
       
        conformMessageView()
        messagesCollectionView.reloadData()
        
    }
    
    func conformMessageView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messageCellDelegate = self
    }
    
}

extension ChatViewController: ConfigureMessageView {
    var currentSender: SenderType {
        selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
}
