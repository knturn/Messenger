//
//  FirebaseAutManager.swift
//  Messenger
//
//  Created by Kaan Turan on 31.08.2022.
//

import FirebaseAuth
import UIKit
class FirebaseAuthManager {
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if (authResult?.user) != nil {
                completionBlock(true)
            }  else {
                completionBlock(false)
            }
        }
    }
    
    func logIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let _ = error {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
}
