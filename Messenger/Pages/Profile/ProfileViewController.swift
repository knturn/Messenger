//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Kaan Turan on 8.09.2022.
//

import UIKit
import JGProgressHUD

class ProfileViewController: UIViewController {
    //MARK: PROPERTIES
    private let spinner = JGProgressHUD(style: .light)
    let vModel = ProfileViewModel()
    let list = 0...10
    
    //MARK: UI ELEMENTS
    private lazy var tableView: UITableView = {
        let tblview = UITableView()
        return tblview
    }()
    
    
    // MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        let logOut = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .done, target: self, action: #selector(signOut))
        navigationController?.navigationBar.backgroundColor = .clear
        navigationItem.rightBarButtonItem = logOut
        view.backgroundColor = .orange
        configureTableView()
    }
    @objc func signOut() {
        vModel.signOut()
        view.window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
    }
    // MARK: FUNCS
    private func createTableViewHeader() -> UIView? {
        guard let email = AuthManager.currentUser?.email else {return nil}
        let path = email.getProfileImagePath()
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
        /*headerView.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width)
            make.height.equalTo(300)
            make.bottom.equalTo(tableView.frame.minY)
        }*/
        view.backgroundColor = .link
        let imageView = UIImageView(frame: CGRect(x: (view.frame.width - 150)/2, y: 75, width: 150, height: 150))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.layer.masksToBounds = true
        vModel.downLoadURL(for: path) { [weak self] url in
            
            guard let self = self, let url = url else { return }
            self.spinner.show(in: imageView, animated: true)
            self.vModel.downloadImage(imageView: imageView, url: url)
            self.spinner.dismiss(animated: true)
        }
        headerView.addSubview(imageView)
        headerView.backgroundColor = .lightGray
        return headerView
    }
  
    private func configureTableView() {
        drawDesign()
        addSubViews()
        makeConstraints()
        let view = createTableViewHeader()
        tableView.tableHeaderView = view
        
    }
    private func drawDesign() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "custom")
    }
    private func addSubViews() {
        view.addSubview(tableView)
    }
    
    // MARK: CONSTRAINTS
    private func makeConstraints(){
        tableView.snp.makeConstraints { make in
            make.right.left.bottom.top.equalToSuperview()
        }
    }
    
}

// MARK: EXTENSİONS
extension ProfileViewController: ConfigureTableView {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Aynnnen"
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
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

