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
        let profile = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill"), style: .done, target: self, action: #selector(goToProfile))
        navigationController?.navigationBar.backgroundColor = .clear
        navigationItem.rightBarButtonItem = profile
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newConversation))
        view.backgroundColor = .white
        configureTableView()
    }
    
    
    //MARK: FUNCS
    @objc func newConversation() {
        let vc = NewConversationViewController()
        let navCont = UINavigationController(rootViewController: vc)
        present(navCont, animated: true)
    }
    private func validateAuth() {
        if vmodel.currentUser == nil {
            let navigationController = UINavigationController(rootViewController: LoginViewController())
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        }
    }
    private func fetchConversations() {
        tableView.isHidden = false
    }
    @objc func goToProfile() {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    private func configureTableView() {
        drawDesign()
        addSubViews()
        makeConstraints()
        
    }
    private func drawDesign() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatListCell.self, forCellReuseIdentifier: "custom")
        
    }
    private func addSubViews() {
        view.addSubview(tableView)
        view.addSubview(noConversationsLabel)
    }
    
    // MARK: CONSTRAINTS
    private func makeConstraints(){
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.right.left.bottom.equalToSuperview()
        }
        noConversationsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
}
// MARK : EXTENSİONS
extension ChatListViewController: ConfigureTableView {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatListCell()
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        12
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController()
        vc.title = "CANIM ANAM"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    func deselectSelectedRow(animated: Bool) {
        
    }
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     23
     }
     */
}
