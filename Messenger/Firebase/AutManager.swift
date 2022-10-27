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
    
    static func configure() {
       let _ = AuthManager.userInfos.userName
        let _ = AuthManager.userInfos.currentUserProfilePictureUrl
    }
    static var currentUser: User? {
        Auth.auth().currentUser
    }
    static var userInfos: UserInfos = UserInfos()
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
            guard error == nil,
                  let authentication = user?.authentication,
                  let idToken = authentication.idToken,
                  let userName = user?.profile?.name,
                  let email = user?.profile?.email
            else {
                print("\(error!.localizedDescription)")
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            let chatUser = ChatAppUser(userName: userName, emailAdress: email)
            let url = user?.profile?.imageURL(withDimension: 200)
            Auth.auth().signIn(with: credential) { [weak self] result, error in
                self?.insertGoogleUserToDB(appUser: chatUser, url: url) { result in
                    if result {
                        completion(true)
                    }
                }
                if error == nil {
                    completion(true)
                }
                
            }
        }
    }
    func insertGoogleUserToDB(appUser: ChatAppUser, url: URL?, completion: @escaping (Bool) -> Void) {
        DatabaseManager.shared.insertUser(with: appUser) { success in
            if success != .error {
                guard let url else {
                    completion(false)
                    return
                }
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data else {
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
// USER INFO'S
class UserInfos {
    init() {
        getName()
        getURL()
    }
    /// USERNAME
    private var name: String?
    var userName: String? {
        get {
            if name == nil {
                getName()
            }
            return name
        }
        set {
             name = nil
        }
    }
     private func getName() {
        DatabaseManager.shared.getCurrentUserName { [weak self] name in
            guard let self else{return}
            self.name = name
        }
    }
   /// PROFILE PICTURE URL
    private func getURL() {
        let path = AuthManager.currentUser?.mailForFirebase?.getProfileImagePath() ?? " "
        StorageManager.shared.downloadURL(for: path) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let url):
                self.url = url
            case .failure(_):
                print("Error happend while showing profile picture")
            }
        }
    }
    private var url: URL?
    var currentUserProfilePictureUrl: URL? {
        get {
            if url == nil {
                getURL()
            }
            return url
        }
        set {
             url = nil
        }
    }
}
