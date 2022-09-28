//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Kaan Turan on 21.09.2022.
//

import UIKit
import JGProgressHUD
class NewConversationViewController: UIViewController {
    //MARK: PROPERTIES
    let vModel = NewConversationViewModel()
    private var users = [[String: String]]()
    private var results = [[String: String]]()
    private var hasFetched = false
    public var completion: (([String: String]) -> Void)?
    // MARK: UI ELEMENTS
    private let spinner = JGProgressHUD(style: .dark)
   
    
    private lazy var searchBar : UISearchBar = {
        let srch = UISearchBar()
        srch.becomeFirstResponder()
        srch.placeholder = "Search for users..."
        return srch
    }()
    private lazy var tableView : UITableView = {
        let tblView = UITableView()
        tblView.isHidden = true
        tblView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tblView
    }()
    private lazy var noResultsLabel : UILabel = {
        let lbl = UILabel()
        lbl.isHidden = true
        lbl.text = "No Results"
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 22, weight: .medium)
        return lbl
    }()
    
    
    // MARK: LİFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmSearchBar()
        conformTableView()
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissSelf))
    }
    // MARK: FUNCS
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
    func confirmSearchBar() {
        searchBar.delegate = self
    }
    func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(noResultsLabel)
    }
    func conformTableView(){
       addSubviews()
       drawDesign()
        makeConstraints()
    }
    func drawDesign() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "custom")
    }
    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        noResultsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
// MARK: EXTENSIONS
extension NewConversationViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {return}
        results.removeAll()
        spinner.show(in: view)
        searchUsers(query: text)
    }
    func searchUsers(query: String) {
        if hasFetched {
            filteredUsers(with: query)
        }
        else {
            DatabaseManager.shared.getAllUsers { [weak self] result in
                switch result {
                case .success(let value):
                    self?.hasFetched = true
                    self?.users = value
                    self?.filteredUsers(with: query)
                case .failure(let error):
                    print("Failed fetch users: \(error)")
                }
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.updateUI()
        }
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func filteredUsers(with term: String) {
        guard hasFetched else{return}
        self.spinner.dismiss(animated: true)
        let results: [[String: String]] = users.filter {
            guard let name = $0["name"]?.lowercased() else{return false}
            return name.hasPrefix(term.lowercased())
        }
        self.results = results
        DispatchQueue.main.async { [weak self] in
            self?.updateUI()
        }
    }
    func updateUI() {
        if results.isEmpty {
            self.noResultsLabel.isHidden = false
            self.tableView.isHidden = true
        }
        else {
            self.noResultsLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}
extension NewConversationViewController : ConfigureTableView {
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = results[indexPath.row]["name"]
            return cell
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            results.count
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            // TODO: Go to conversation Screen
            let targetUserData = results[indexPath.row]
            dismiss(animated: true) { [weak self] in 
                self?.completion?(targetUserData)
            }
            
        }
     
    
}

