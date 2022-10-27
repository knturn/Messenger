//
//  HomeViewController.swift
//  Messenger
//
//  Created by Kaan Turan on 2.09.2022.
//

import UIKit
import JGProgressHUD
import GoogleSignIn

class ChatListViewController: UIViewController {
    //MARK: PROPERTIES
    let vmodel = ChatListViewModel()
    private let spinner = JGProgressHUD(style: .dark)
    
    
    // MARK: UI ELEMENT
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        return table
    }()
    private lazy var noConversationsLabel: UILabel = {
        let lbl = UILabel()
        lbl.isHidden = true
        lbl.text = "There is no conversation yet!"
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.textColor = .gray
        lbl.font = .systemFont(ofSize: 22, weight: .medium)
        return lbl
    }()
    
    
    // MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        validateAuth()
        fetchConversations()
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Chats"
        let font = UIFont.systemFont(ofSize: 20)
        let attributes = [NSAttributedString.Key.font: font]
        let attirubettext = NSAttributedString(string: "Profile", attributes: attributes)
        let profile = UIBarButtonItem(title: attirubettext.string, style: .done, target: self, action: #selector(goToProfile))
        navigationController?.navigationBar.backgroundColor = .clear
        navigationItem.rightBarButtonItem = profile
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newConversation))
        view.backgroundColor = .white
        configureTableView()
    }
    
    //MARK: FUNCS
    /// Check currenUser. If currentUser == nil present login screen.
    private func validateAuth() {
        if AuthManager.currentUser == nil {
            let navigationController = UINavigationController(rootViewController: LoginViewController())
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        }
        AuthManager.userInfos.userName == nil ? AuthManager.configure() : nil
    }
    /// New conversation screen present and create new chat screen
    @objc private func newConversation() {
        let vc = NewConversationViewController()
        vc.completion = { [weak self] conversation in
            self?.createNewConv(with: conversation)
        }
        let navCont = UINavigationController(rootViewController: vc)
        present(navCont, animated: true)
    }
    private func createNewConv(with conv: Conversation) {
        let vc = ChatViewController(with: conv)
        vc.title = vmodel.getUserName(for: conv)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
   /// Fetch all conversations for currentUser
    private func fetchConversations() {
        vmodel.fetchConversations() { [weak self] result in
            if result {
                DispatchQueue.main.async {
                    if self?.vmodel.conversationsLength() == 0 {
                        self?.noConversationsLabel.isHidden = false
                    } else {
                        self?.tableView.isHidden = false
                        self?.tableView.reloadData()
                    }
                }
            }
            else {
                print("error")
            }
        }
    }
    /// Go to chat page for choosen chat.
    private func goToChatPage(index: Int) {
        let conv = vmodel.getConversation(int: index)
        let vc = ChatViewController(with: conv)
        vc.title = vmodel.getUserName(for: conv)
        DispatchQueue.main.async { [weak self] in
            vc.navigationItem.largeTitleDisplayMode = .never
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    /// Go to profile page
    @objc private func goToProfile() {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    // MARK: CONFIGURE TABLEVIEW
    private func configureTableView() {
        drawDesign()
        addSubViews()
        makeConstraints()
    }
    
    private func drawDesign() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.identifier)
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
        view.addSubview(noConversationsLabel)
    }
    
    // MARK: CONSTRAINTS
    private func makeConstraints(){
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.left.bottom.equalToSuperview()
        }
        noConversationsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
}

// MARK: EXTENSIONS
extension ChatListViewController: ConfigureTableView {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatListCell.identifier, for: indexPath) as? ChatListCell
        else{return UITableViewCell()}
        let conv = vmodel.getConversation(int: indexPath.row)
        cell.addUserInformation(for: conv)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vmodel.conversationsLength()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        goToChatPage(index: indexPath.row)
    }
    func deselectSelectedRow(animated: Bool) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
}
