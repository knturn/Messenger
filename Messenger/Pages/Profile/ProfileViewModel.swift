//
//  ProfileViewModel.swift
//  Messenger
//
//  Created by Kaan Turan on 20.09.2022.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

final class ProfileViewModel {
    let userInfos = [0: "Username: \(AuthManager.userInfos.userName ?? "")", 1: "Email: \(AuthManager.currentUser?.email ?? "")"]
    let currentUser = FirebaseAuth.Auth.auth().currentUser
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        do  {
            try FirebaseAuth.Auth.auth().signOut()
            AuthManager.userInfos.userName = nil
            AuthManager.userInfos.currentUserProfilePictureUrl  = nil
        }
        catch {
            print("Can't sign out")
        }
    }
}
