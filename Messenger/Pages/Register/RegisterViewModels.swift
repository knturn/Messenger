//
//  RegisterModels.swift
//  Messenger
//
//  Created by Kaan Turan on 30.08.2022.
//

import Foundation


final class RegisterViewModels {
    private var email: String?
    private var name: String?
    private var password: String?
    private var imageData: Data?
    
    // MARK: FUNCS
    func setUserInfo(email: String, name: String, password: String, imageData: Data?) {
        self.password = password
        self.email = email
        self.name = name
        self.imageData = imageData
    }
    func newUser(completionBlock: @escaping (_ success: Bool) -> Void) {
        guard let password = password, let email = email else {
            completionBlock(false)
            return
        }
        
        let signUpManager = AuthManager()
        signUpManager.createUser(email: email, password: password) {  [weak self] result in
            if result {
                self?.insertUser()
            }
            
            completionBlock(result)
        }
    }
    private func insertUser(){
        guard let name = name, let email = email else {
            return
        }
        let user = ChatAppUser(userName: name, emailAdress: email)
        DatabaseManager.shared.insertUser(with: user) { [weak self ] result in
            guard let self else { return }
            if result != .error {
                self.loadProfilePic(data: self.imageData, fileName: user.profilePictureFileName)
            }
            else {
                print("Something went wrong while inserting user to DB")
            }
            
        }
    }
    private func loadProfilePic(data: Data?, fileName: String) {
        guard let data = data else { return }
        
        StorageManager.shared.uploadProfilePic(with: data, fileName: fileName) { result in
            switch result {
            case .success(let downloadURL):
                print(downloadURL)
                //UserDefaults.standard.set(downloadURL, forKey: "profile_picture_url")
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
}
