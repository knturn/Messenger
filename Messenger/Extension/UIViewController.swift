//
//  UIViewController.swift
//  Messenger
//
//  Created by Kaan Turan on 31.08.2022.
//

import UIKit

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension Notification.Name {
    static let didloginNotification = Notification.Name("didloginNotification")
}
