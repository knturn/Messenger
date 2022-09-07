//
//  LoginViewModel.swift
//  Messenger
//
//  Created by Kaan Turan on 1.09.2022.
//

import Foundation

final class LoginViewModel {
    
    @objc func logIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        let loginManager = FirebaseAuthManager()
        loginManager.logIn(email: email, pass: pass) { success in
            completionBlock(success)
        }
    }
}
