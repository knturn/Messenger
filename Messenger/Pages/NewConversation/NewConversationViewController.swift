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
    var completion: ((Conversation)-> Void)?
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
        spinner.show(in: view)
        searchUsers(query: text)
    }
    func searchUsers(query: String) {
            vModel.getUsers(query: query) { [weak self] result in
                guard let self else {return}
                if result  {
                    DispatchQueue.main.async {
                        self.spinner.dismiss(animated: true)
                        self.updateUI()
                    }
                }
            }
        }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func updateUI() {
        let isFetched = vModel.resultCount() == 0
        if
            isFetched {
            noResultsLabel.isHidden = false
            tableView.isHidden = true
        }
        else {
            noResultsLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}
extension NewConversationViewController : ConfigureTableView {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let name = vModel.resultsName(by: indexPath.row){
            cell.textLabel?.text = name
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vModel.resultCount()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: Go to conversation Screen
        let target = vModel.searchedUser(by: indexPath.row)
        vModel.goToChatPage(with: target) { [weak self] conversation in
            guard let self else{return}
            self.dismiss(animated: true) {
                self.completion?(conversation)
            }
            
        }
    }
}

