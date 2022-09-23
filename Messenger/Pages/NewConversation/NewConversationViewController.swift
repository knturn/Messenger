//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Kaan Turan on 21.09.2022.
//

import UIKit
import JGProgressHUD
class NewConversationViewController: UIViewController {
    // MARK: UI ELEMENTS
    private let spinner = JGProgressHUD()
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
    


}

extension NewConversationViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
