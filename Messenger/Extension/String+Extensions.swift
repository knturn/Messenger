//
//  StringExtension.swift
//  Messenger
//
//  Created by Kaan Turan on 26.09.2022.
//

import Foundation
import UIKit

extension String {
    func getProfileImagePath() -> String {
       let safeEmail = self.replacingOccurrences(of: ".", with: "-")
        let generalProfilePicturePath = "_profile_picture.png"
        return "images/" + safeEmail + generalProfilePicturePath
    }
}
extension String {
    func textfieldHintFormat() -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.boldSystemFont(ofSize: 14.0)
        ])
    }
}
