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
    let currentUser = FirebaseAuth.Auth.auth().currentUser
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        do  {
        try FirebaseAuth.Auth.auth().signOut()
        }
        catch {
            print("Can't sign out")
        }
    }
    
}
