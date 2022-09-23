//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Kaan Turan on 8.09.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    let vModel = ProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let logOut = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .done, target: self, action: #selector(signOut))
        navigationController?.navigationBar.backgroundColor = .clear
        navigationItem.rightBarButtonItem = logOut
        view.backgroundColor = .orange
    }
    @objc func signOut() {
        vModel.signOut()
        view.window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
