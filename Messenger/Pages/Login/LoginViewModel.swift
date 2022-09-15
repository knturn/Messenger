//
//  LoginViewModel.swift
//  Messenger
//
//  Created by Kaan Turan on 1.09.2022.
//

import UIKit.UIViewController

final class LoginViewModel {
    
     func logIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        let loginManager = FirebaseAuthManager()
        loginManager.logIn(email: email, pass: pass) { success in
            completionBlock(success)
        }
    }
    func googleSign(view: UIViewController, completionBlock: @escaping () -> Void) {
        let loginManager = FirebaseAuthManager()
        loginManager.useGoogle(view: view) {
            completionBlock()
        }
    }
    
    
}
