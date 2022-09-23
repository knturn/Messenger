//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Kaan Turan on 30.08.2022.
//

import UIKit
import JGProgressHUD

final class RegisterViewController: UIViewController {
    let vModel = RegisterViewModels()
    private let spinner = JGProgressHUD(style: .dark)
    
    // MARK: UI ELEMENTS
    private lazy var image: UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
        img.addGestureRecognizer(gesture)
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        img.layer.cornerRadius = CGFloat(72)
        img.layer.borderWidth = 2
        img.layer.borderColor = UIColor.lightGray.cgColor
        img.image = UIImage(systemName: "person.circle")
        return img
    }()
    private lazy var userNameField: CustomTextField = {
        let txt = CustomTextField()
        txt.attributedPlaceholder = NSAttributedString(string: "Username:", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.boldSystemFont(ofSize: 14.0)
        ])
        
        txt.autocorrectionType = UITextAutocorrectionType.no
        txt.layer.borderWidth = 2
        txt.layer.borderColor = UIColor.gray.cgColor
        txt.layer.cornerRadius = 12
        return txt
    }()
    private lazy var emailTextField: CustomTextField = {
        let txt = CustomTextField()
        txt.attributedPlaceholder = NSAttributedString(string: "Email:", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.boldSystemFont(ofSize: 14.0)
        ])
        txt.autocorrectionType = UITextAutocorrectionType.no
        txt.autocapitalizationType = UITextAutocapitalizationType.none
        txt.layer.borderWidth = 2
        txt.layer.borderColor = UIColor.gray.cgColor
        txt.layer.cornerRadius = 12
        return txt
    }()
    
    private lazy var passTextField: CustomTextField = {
        let txt = CustomTextField()
        txt.attributedPlaceholder = NSAttributedString(string: "Password: Have to be longer than 6 character", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.boldSystemFont(ofSize: 14.0)
        ])
        txt.autocorrectionType = UITextAutocorrectionType.no
        txt.autocapitalizationType = UITextAutocapitalizationType.none
        txt.layer.borderWidth = 2
        txt.layer.borderColor = UIColor.gray.cgColor
        txt.borderStyle = .roundedRect
        txt.layer.cornerRadius = 12
        txt.isSecureTextEntry = true
        return txt
    }()
    private lazy var confirmPassTextField: CustomTextField = {
        let txt = CustomTextField()
        txt.attributedPlaceholder = NSAttributedString(string: "Confirm your password", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.boldSystemFont(ofSize: 14.0)
        ])
        txt.layer.borderWidth = 2
        txt.layer.borderColor = UIColor.gray.cgColor
        txt.borderStyle = .roundedRect
        txt.layer.cornerRadius = 12
        txt.isSecureTextEntry = true
        return txt
    }()
    
    
    private lazy var registerButton: UIButton = {
        let reg = UIButton(type: .system)
        reg.layer.borderWidth = 1
        reg.layer.cornerRadius = 12
        reg.backgroundColor = .systemGreen
        reg.setTitle("Register", for: .normal)
        reg.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        reg.setTitleColor(UIColor.white, for: .normal)
        reg.addTarget(self, action: #selector(registerConfirm), for: .touchUpInside )
        reg.translatesAutoresizingMaskIntoConstraints = false
        return reg
    }()
    private lazy var logButton: UIButton = {
        let log = UIButton(type: .system)
        log.setTitle("Do you already have an account?", for: .normal)
        log.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        log.setTitleColor(UIColor.blue, for: .normal)
        log.addTarget(self, action: #selector(goToLogin), for: .touchUpInside )
        log.translatesAutoresizingMaskIntoConstraints = false
        return log
    }()
    
    
    
    // MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Create Account"
        view.backgroundColor = .white
        addSubviews()
        makeConstraints()
    }
    
    // MARK: FUNCTIONS
    @objc func goToLogin(){
        view.window?.rootViewController = LoginViewController()
    }
    @objc func registerConfirm() {
        emailTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
        guard emailTextField.text?.count != 0 else {
            emailTextField.placeholder = "Please write your emaill adress"
            let alertController = UIAlertController(title: nil, message: "You can not leave the email field blank", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.display(alertController: alertController)
            return
        }
        
        guard passTextField.text?.count ?? 0 >= 6 && passTextField.text == confirmPassTextField.text  else {
            let alertController = UIAlertController(title: nil, message: "Password is not matched", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.display(alertController: alertController)
            return
        }
        spinner.show(in: view, animated: true)
        vModel.newUser(mail: emailTextField.text!, pass: passTextField.text!) { [weak self] success in
            guard let strSelf = self else{
                return
            }
            var message = ""
            if success {
                message = "User was created succesfully"
                guard let email = strSelf.emailTextField.text,
                      let name = strSelf.userNameField.text else {
                    return
                }
                let chatUser = ChatAppUser(userName: name, emailAdress: email)
                strSelf.vModel.insertUser(user: chatUser, completionBlock: { success in
                    
                    if success {
                        guard let image = strSelf.image.image,
                              let data = image.pngData()
                        else {
                            return
                        }
                        let fileName = chatUser.profilePictureFileName
                        strSelf.vModel.loadProfilePic(data: data, fileName: fileName)
                    }
                })
                strSelf.navigationController?.dismiss(animated: true)
            }
            else {
                message = "There was an error"
            }
            
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                if success {
                    strSelf.view.window?.rootViewController = LoginViewController()
                }
                else {
                    return
                }
            }))
            strSelf.display(alertController: alertController)
            DispatchQueue.main.async {
                strSelf.spinner.dismiss(animated: true)
            }
            
        }
        
        
    }
    @objc func didTapProfilePic(){
        presentImgPicker()
        
    }
    
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func addSubviews() {
        view.addSubview(emailTextField)
        view.addSubview(passTextField)
        view.addSubview(registerButton)
        view.addSubview(confirmPassTextField)
        view.addSubview(image)
        view.addSubview(userNameField)
        view.addSubview(logButton)
        
    }
    
    func makeConstraints() {
        image.snp.makeConstraints { make in
            make.height.equalTo(view.snp.height).dividedBy(4.0)
            make.centerX.equalToSuperview()
            make.width.equalTo(view).dividedBy(2.0)
            make.bottom.equalTo(userNameField.snp.top).offset(-55)
        }
        userNameField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-20)
        }
        
        emailTextField.snp.makeConstraints { make in
            
            make.height.equalTo(40)
            make.top.equalTo(userNameField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-20)
            
        }
        
        passTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-20)
        }
        
        confirmPassTextField.snp.makeConstraints { make in
            make.top.equalTo(passTextField.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-20)
        }
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPassTextField.snp.bottom).offset(20)
            make.height.equalTo(25)
            make.left.equalToSuperview().offset(80)
            make.right.equalToSuperview().offset(-80)
        }
        logButton.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(20)
            make.height.equalTo(25)
            make.left.equalToSuperview().offset(70)
            make.right.equalToSuperview().offset(-70)
        }
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func presentImgPicker(){
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 25)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleString = NSAttributedString(string: "Profile Picture", attributes: titleAttributes)
        let messageAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.red]
        let messageString = NSAttributedString(string: "Let's see how would you look like!", attributes: messageAttributes)
        
        let actionsheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionsheet.addAction(UIAlertAction(title: "Take picture", style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            let sourceType = UIImagePickerController.isSourceTypeAvailable(.camera)
            if sourceType {
                picker.sourceType = .camera
            }
            
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        }
                                           ))
        actionsheet.addAction(UIAlertAction(title: "Choose a picture", style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        }
                                           ))
        actionsheet.setValue(titleString, forKey: "attributedTitle")
        actionsheet.setValue(messageString, forKey: "attributedMessage")
        present(actionsheet, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else{return}
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        self.image.image = image
        dismiss(animated: true)
    }
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
