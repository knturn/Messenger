//
//  LoginViewModel.swift
//  Messenger
//
//  Created by Kaan Turan on 1.09.2022.
//

import UIKit.UIViewController

final class LoginViewModel {
    
     func logIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        let loginManager = AuthManager()
        loginManager.logIn(email: email, pass: pass) { success in
            completionBlock(success)
        }
    }
    func googleSign(view: UIViewController, completion: @escaping (Bool) -> Void) {
        let loginManager = AuthManager()
        loginManager.useGoogle(view: view){ result in
            completion(result)
        }
    }
    
    
    
}
