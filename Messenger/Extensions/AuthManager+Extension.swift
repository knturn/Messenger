//
//  AuthManager+Extension.swift
//  Messenger
//
//  Created by Kaan Turan on 1.10.2022.
//

import Foundation
import FirebaseAuth


extension User {
    var mailForFirebase: String? {
        let fireBase = (self.email)?.replacingOccurrences(of: ".", with: "-")
        let emailFor = fireBase?.replacingOccurrences(of: "_", with: "-")
        return emailFor
    }
}


