//
//  FirebaseAutManager.swift
//  Messenger
//
//  Created by Kaan Turan on 31.08.2022.
//

import FirebaseAuth
import FirebaseCore
import GoogleSignIn
class AuthManager {
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
    func useGoogle(view: UIViewController, completionBlock: @escaping () -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: view) { user, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) {
                _, _ in
                guard let userName = user?.profile?.name,
                      let email = user?.profile?.email else {
                    return
                }
                NotificationCenter.default.post(name: .didloginNotification, object: nil)
                let chatUser = ChatAppUser(userName: userName, emailAdress: email)
                DatabaseManager.shared.insertUser(with: chatUser) { success in
                    if success{
                        if user?.profile?.hasImage ?? false {
                            guard let url = user?.profile?.imageURL(withDimension: 200) else {
                                return
                            }
                            URLSession.shared.dataTask(with: url) { data, response, error in
                                guard let data = data else {
                                    return
                                }
                                let fileName = chatUser.profilePictureFileName
                                StorageManager.shared.uploadProfilePic(with: data, fileName: fileName) { result in
                                    switch result {
                                    case .success(let downloadURL):
                                        print(downloadURL)
                                        UserDefaults.standard.set(downloadURL, forKey: "profile_picture_url")
                                        UserDefaults.standard.set(email, forKey: "email")
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                                
                            }.resume()
                        }
                        
                    }
                }
            }
            completionBlock()
            
        }
    }
}

