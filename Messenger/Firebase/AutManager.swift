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
    static var currentUser: User? {
        Auth.auth().currentUser
    }
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            completionBlock((authResult?.user) != nil)
        }
    }
    
    func logIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            completionBlock(error == nil)
        }
    }
    func useGoogle(view: UIViewController, completion: @escaping (Bool) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: view) { user, error in
            guard
                error == nil,
                let authentication = user?.authentication,
                let idToken = authentication.idToken,
                let userName = user?.profile?.name,
                let email = user?.profile?.email
            else { print("\(error!.localizedDescription)")
                return}
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            let chatUser = ChatAppUser(userName: userName, emailAdress: email)
            let url = user?.profile?.imageURL(withDimension: 200)
            Auth.auth().signIn(with: credential) {
                _, _ in
                AuthManager.insertGoogleUserToDB(self)(appUser: chatUser, url: url) { result in
                    if result {
                        completion(true)
                        NotificationCenter.default.post(name: .didloginNotification, object: nil)
                    }
                    else {
                        NotificationCenter.default.post(name: .loginFailedNotification, object: nil)
                        completion(false)
                    }
                }
                
            }
        }
    }
    func insertGoogleUserToDB(appUser: ChatAppUser, url: URL?, completion: @escaping (Bool) -> Void) {
        DatabaseManager.shared.insertUser(with: appUser) { success in
            if success {
                guard let url = url else {
                    return
                }
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data else {
                        return
                    }
                    let fileName = appUser.profilePictureFileName
                    StorageManager.shared.uploadProfilePic(with: data, fileName: fileName) { result in
                        switch result {
                        case .success(let downloadURL):
                            print(downloadURL)
                            completion(true)
                            
                            //UserDefaults.standard.set(downloadURL, forKey: "profile_picture_url")
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                }.resume()
            } else {
                completion(false)
            }
        }
    }
    
}

