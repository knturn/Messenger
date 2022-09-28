//
//  CustomTextField.swift
//  Messenger
//
//  Created by Kaan Turan on 31.08.2022.
//

import UIKit.UITextField

class CustomTextField: UITextField {
    
    // MARK: UIELEMENTS
    
    // MARK: FUNCTIONS
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override init(frame: CGRect) {
            super.init(frame: frame)
            textFieldSetup()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            textFieldSetup()
        }

    private func textFieldSetup() {
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.gray.cgColor
            self.borderStyle = .roundedRect
            self.layer.cornerRadius = 12
        }
}

