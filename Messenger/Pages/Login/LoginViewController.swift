//
//  LoginViewController.swift
//  Messenger
//
//  Created by Kaan Turan on 30.08.2022.
//

import UIKit

class LoginViewController: UIViewController {
    let vModel = LoginViewModel()
    
    // MARK: UI ELEMENTS
    private lazy var image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "login")
        return img
    }()
    private lazy var emailTextField: CustomTextField = {
        let txt = CustomTextField()
        txt.placeholder = "Email:"
        txt.autocorrectionType = UITextAutocorrectionType.no
        txt.autocapitalizationType = UITextAutocapitalizationType.none
        txt.layer.borderWidth = 2
        txt.layer.borderColor = UIColor.gray.cgColor
        txt.layer.cornerRadius = 10
        return txt
    }()
    
    private lazy var passTextField: CustomTextField = {
        let txt = CustomTextField()
        txt.placeholder = "Password:"
        txt.autocorrectionType = UITextAutocorrectionType.no
        txt.autocapitalizationType = UITextAutocapitalizationType.none
        txt.layer.borderWidth = 2
        txt.layer.borderColor = UIColor.gray.cgColor
        txt.borderStyle = .roundedRect
        txt.layer.cornerRadius = 10
        txt.isSecureTextEntry = true
        return txt
    }()
    
    
    private lazy var logInButton: UIButton = {
        let reg = UIButton(type: .system)
        reg.layer.borderWidth = 1
        reg.layer.cornerRadius = 12
        reg.backgroundColor = .systemBlue
        reg.setTitle("Login", for: .normal)
        reg.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        reg.setTitleColor(UIColor.white, for: .normal)
        reg.addTarget(self, action: #selector(logIn), for: .touchUpInside )
        reg.translatesAutoresizingMaskIntoConstraints = false
        return reg
    }()
    private lazy var regButton: UIButton = {
        let reg = UIButton(type: .system)
        reg.setTitle("Don't you have an account yet?", for: .normal)
        reg.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        reg.setTitleColor(UIColor.blue, for: .normal)
        reg.addTarget(self, action: #selector(goToRegister), for: .touchUpInside )
        reg.translatesAutoresizingMaskIntoConstraints = false
        return reg
    }()
    
    
    
    // MARK: LİFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "LOGIN"
        view.backgroundColor = .white
        addSubviews()
        makeConstraints()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: FUNCS
    @objc func logIn() {
        vModel.logIn(email: emailTextField.text!, pass: passTextField.text!) { success in
            var message = ""
            if success {
                message = "Succesfully logged in"
            } else {
                message = "Oo no!"
            }
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in
                guard success else {return}
                    self.view.window?.rootViewController = HomeViewController()
                
            }))
            self.display(alertController: alertController)
        }
    }
    @objc func goToRegister(){
        navigationController?.pushViewController(RegisterViewController(), animated: true)
        navigationController?.navigationBar.isHidden = false
    }
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
        
    }
    func addSubviews() {
        view.addSubview(emailTextField)
        view.addSubview(passTextField)
        view.addSubview(logInButton)
        view.addSubview(regButton)
        view.addSubview(image)
        
    }
    
    func makeConstraints() {
        image.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalTo(emailTextField.snp.top).offset(-15)
        }
        
        emailTextField.snp.makeConstraints { make in
            
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-20)
            
        }
        
        passTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-20)
        }
        
        logInButton.snp.makeConstraints { make in
            make.top.equalTo(passTextField.snp.bottom).offset(20)
            make.height.equalTo(25)
            make.left.equalToSuperview().offset(100)
            make.right.equalToSuperview().offset(-100)
            
        }
        regButton.snp.makeConstraints { make in
            make.top.equalTo(logInButton.snp.bottom).offset(20)
            make.height.equalTo(25)
            make.left.equalToSuperview().offset(70)
            make.right.equalToSuperview().offset(-70)
            
        }
        
    }
    
    
}
