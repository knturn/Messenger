//
//  HomeViewController.swift
//  Messenger
//
//  Created by Kaan Turan on 2.09.2022.
//

import UIKit
import GoogleSignIn

class ChatListViewController: UIViewController {
    let vmodel = ChatListViewModel()
    
    // MARK: UI ELEMENT
    private let tableView : UITableView = {
        let table = UITableView()
        return table
    }()
    
    
    // MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        validateAuth()
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(signOut))
        view.backgroundColor = .white
        configureTableView()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationItem.rightBarButtonItem = doneItem
    }
    
    //MARK: FUNCS
    private func validateAuth() {
        if vmodel.currentUser == nil {
            let navigationController = UINavigationController(rootViewController: LoginViewController())
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        }
    }
    @objc func signOut() {
        vmodel.signOut()
        view.window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
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
    }
    
    // MARK: CONSTRAINTS
    private func makeConstraints(){
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.right.left.bottom.equalToSuperview()
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
        
    }
    func deselectSelectedRow(animated: Bool) {
        
    }
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     23
     }
     */
}
