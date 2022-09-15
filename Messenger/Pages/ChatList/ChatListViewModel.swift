//
//  ChatPageViewModel.swift
//  Messenger
//
//  Created by Kaan Turan on 9.09.2022.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
final class ChatListViewModel {
    let currentUser = FirebaseAuth.Auth.auth().currentUser
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    
}
