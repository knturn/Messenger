//
//  ChatPageCell.swift
//  Messenger
//
//  Created by Kaan Turan on 9.09.2022.
//

import UIKit

class ChatListCell: UITableViewCell {
    static let identifier: String = "custom"
    //MARK: UIELEMENTS
    private lazy var userName: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        label.text = "Helllo"
        return label
    }()
    private lazy var profilePic: UIImageView = {
        let image = UIImageView()
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
    private func addViews() {
        addSubview(userName)
        addSubview(profilePic)
    }
    private func makeConstraints() {
        
        userName.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    
}
