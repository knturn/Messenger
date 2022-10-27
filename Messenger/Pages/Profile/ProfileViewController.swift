//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Kaan Turan on 8.09.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    //MARK: PROPERTIES
    let vModel = ProfileViewModel()
    //MARK: UI ELEMENTS
    private lazy var tableView: UITableView = {
        let tblview = UITableView()
        return tblview
    }()
    
    
    // MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        let logOut = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(signOut))
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
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 400))
        view.backgroundColor = .link
        let imageView = UIImageView(frame: CGRect(x: (view.frame.width - 180)/2, y: 110, width: 200, height: 200))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.layer.masksToBounds = true
        DispatchQueue.main.async {
            guard let url: URL = AuthManager.userInfos.currentUserProfilePictureUrl else{
                imageView.image = UIImage(systemName: "person")
                return
            }
            imageView.sd_setImage(with: url)
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
        tableView.contentMode = .center
    }
    private func addSubViews() {
        view.addSubview(tableView)
    }
    
    // MARK: CONSTRAINTS
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: EXTENSİONS
extension ProfileViewController: ConfigureTableView {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        createProfileViewCell(indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vModel.userInfos.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    private func createProfileViewCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath)
        cell.layer.masksToBounds = true
        cell.accessoryView = UIImageView(image: UIImage(systemName: "pencil"))
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 2
        cell.layer.shadowOffset = CGSize(width: -1, height: 2)
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.contentMode = .center
        cell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        cell.textLabel?.text = vModel.userInfos[indexPath.row]
        return cell
    }
    
}
