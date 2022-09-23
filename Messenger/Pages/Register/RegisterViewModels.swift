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
        let signUpManager = AuthManager()
        signUpManager.createUser(email: mail, password: pass) { success in
            completionBlock(success)
        }
    }
    func insertUser(user: ChatAppUser, completionBlock: @escaping (_ success: Bool) -> Void){
        DatabaseManager.shared.insertUser(with: user) { success in
            completionBlock(success)
        }
    }
    func loadProfilePic(data: Data, fileName: String) {
        StorageManager.shared.uploadProfilePic(with: data, fileName: fileName) { result in
            switch result {
            case .success(let downloadURL):
                print(downloadURL)
                UserDefaults.standard.set(downloadURL, forKey: "profile_picture_url")
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
}
