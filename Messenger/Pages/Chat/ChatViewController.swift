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
    public let conversation: Conversation
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: LIFE CYCLE
    init(with conv: Conversation) {
        self.conversation = conv
        super.init(nibName: nil, bundle: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        conformMessageView()
        vModel.getMessages(conv: conversation) { [weak self] result in
            guard let self else{return}
            if result {
                // Need set up.
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: true)
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: FUNCS
    func conformMessageView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        configureMessageInputBar()
    }
    func configureMessageInputBar() {
        messageInputBar.inputTextView.tintColor = .black
        messageInputBar.sendButton.setTitleColor(.orange, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.black.withAlphaComponent(0.3),
            for: .highlighted)
    }
    
}
// MARK: EXTENSIONS

extension ChatViewController: ConfigureMessageView {
    var currentSender: SenderType {
        Sender.selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return vModel.getMessageForRow(int: indexPath.section)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        vModel.messages.count
    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        vModel.getProfilePicture(message: message) { url in
            DispatchQueue.main.async {
                avatarView.sd_setImage(with: url)
            }
        }
    }
}
extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else{ return }
        vModel.sendMessage(to: conversation, content: text)
        inputBar.inputTextView.text = ""
    }
    
}
