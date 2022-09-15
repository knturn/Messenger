//
//  RegisterModels.swift
//  Messenger
//
//  Created by Kaan Turan on 30.08.2022.
//

import Foundation


final class RegisterViewModels {
    
    // MARK: FUNCS
    func newUser(mail: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        let signUpManager = FirebaseAuthManager()
        signUpManager.createUser(email: mail, password: pass) {(success) in
            completionBlock(success)
        }
    }
    func insertUser(email: String, name: String){
        let user = ChatAppUser(userName: name, emailAdress: email)
        DatabaseManager.shared.insertUser(with: user)
    }
    
    
}
