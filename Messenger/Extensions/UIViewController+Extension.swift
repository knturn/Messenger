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
    //static let didloginNotification = Notification.Name("didloginNotification")
    //static let loginFailedNotification = Notification.Name("loginFailed")
}

extension UIViewController {
    func displayAlert(title: String? = nil, message: String, buttonTitle: String = "OK", handler: @escaping (UIAlertAction) -> Void = {_ in } ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: handler))
        present(alertController, animated: true, completion: nil)
    }
}
