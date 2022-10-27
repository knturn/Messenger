//
//  ChatPageCell.swift
//  Messenger
//
//  Created by Kaan Turan on 9.09.2022.
//

import UIKit
import SDWebImage

class ChatListCell: UITableViewCell {
    static let identifier: String = "custom"
    static var urlArray = [String: URL]()
    //MARK: UIELEMENTS
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    private lazy var userMessageLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        return label
    }()
    private lazy var profilePic: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 50
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    // MARK: DEFAULT FUNCS
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: EXTENSİONS
extension ChatListCell {
    private func configure() {
        addViews()
        makeConstraints()
    }
    func addUserInformation(for conversation: Conversation) {
        let userMails = conversation.users.keys
        let otherUserMail = userMails.filter { $0 != AuthManager.currentUser?.mailForFirebase}.first ?? "there was an error"
        getProfilePic(otherUserEmail: otherUserMail)
        userNameLabel.text = conversation.users[otherUserMail]
        userMessageLabel.text = conversation.messages.kind.messageKindString
        
    }
    private func getProfilePic(otherUserEmail: String) {
        let path = otherUserEmail.getProfileImagePath()
        if ChatListCell.urlArray.keys.contains(otherUserEmail) {
            profilePic.sd_setImage(with: ChatListCell.urlArray[otherUserEmail])
        }
        else {
            StorageManager.shared.downloadURL(for: path) { [weak self] result in
                switch result {
                case .success(let url):
                    ChatListCell.urlArray[otherUserEmail] = url
                    DispatchQueue.main.async { [weak self] in
                        self?.profilePic.sd_setImage(with: url)
                    }
                case .failure(let error):
                    print(error)
                    self?.profilePic.image = UIImage(systemName: "person.fill.questionmark")
                    self?.profilePic.contentMode = .scaleAspectFit
                }
            }
        }
    }
    
    private func addViews() {
        addSubview(profilePic)
        addSubview(userNameLabel)
        addSubview(userMessageLabel)
    }
    private func makeConstraints() {
        profilePic.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(-2)
            make.width.equalTo(100)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        userNameLabel.snp.makeConstraints { make in
            make.left.equalTo(profilePic.snp.right).offset(10)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-40)
            make.right.equalToSuperview().offset(-2)
        }
        userMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalTo(profilePic.snp.right).offset(15)
            make.right.equalToSuperview().offset(-2)
        }
    }
    
    
    
}
