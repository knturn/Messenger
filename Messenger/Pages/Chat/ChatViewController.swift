//
//  ChatViewController.swift
//  Messenger
//
//  Created by Kaan Turan on 15.09.2022.
//
import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController  {
    //MARK: PROPERTIES
    let vModel = ChatViewModel()
    public let otherUserEmail: String
    public var isNewConversation: Bool = false
    private let selfSender: Sender = {
        guard let email = AuthManager.currentUser?.email else{ return Sender(photoURL: "", senderId: "", displayName: "")}
         let photoURL = "ss"
         let displayName = "Kaan Turan"
        return Sender(photoURL: photoURL, senderId: email, displayName: displayName)
    }()
    
    
    init(with email: String) {
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        conformMessageView()
        messagesCollectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    // MARK: FUNCS
    func conformMessageView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
    }
    
}
// MARK: EXTENSIONS

extension ChatViewController: ConfigureMessageView {
    var currentSender: SenderType {
        selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return vModel.messages[indexPath.row]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return vModel.messages.count
    }
    
}
extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else{ return }
        
        print("Sending \(text)")
        // TODO: Send Messages
        if isNewConversation {
            // TODO: Create new conversation on database
            let message = Message(sender: selfSender, messageId: vModel.createMessageID(with: otherUserEmail), sentDate: Date(), kind: .text("aa"))
            vModel.createNewConversations(with:  message){ success in
                
            }
        }
        else {
            // Add existing one
            let message = Message(sender: selfSender, messageId: vModel.createMessageID(with: otherUserEmail), sentDate: Date(), kind: .text("aa"))
            vModel.sendMessage(with: message) { success in
            }
        }
    }
   
}

