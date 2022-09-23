//
//  LoginViewController.swift
//  Messenger
//
//  Created by Kaan Turan on 30.08.2022.
//

import UIKit
import GoogleSignIn
import JGProgressHUD

class LoginViewController: UIViewController {
    let vModel = LoginViewModel()
    private let spinner = JGProgressHUD(style: .dark)
    private var loginObserver: NSObjectProtocol?
    
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
    private lazy var googleSignButton: GIDSignInButton = {
        let bttn = GIDSignInButton()
        let actn = UIAction { [weak self] _ in
            self?.googleLoginButtonTapped()
        }
        bttn.addAction(actn, for: .touchUpInside)
        bttn.style = .wide
        return bttn
    }()
    
    
    
    // MARK: LİFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        loginObserver =  NotificationCenter.default.addObserver(forName: .didloginNotification, object: nil, queue: .main) { [weak self] _ in
            guard let strSelf = self else {return}
            strSelf.navigationController?.dismiss(animated: true)
        }
        view.backgroundColor = .white
        addSubviews()
        makeConstraints()
    }
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: FUNCS
    func googleLoginButtonTapped() {
        vModel.googleSign(view: self) {
            let navigationController = UINavigationController(rootViewController: ChatListViewController())
            self.view.window?.rootViewController = navigationController
        }
        
    }
    
    
    @objc func logIn() {
        spinner.show(in: view, animated: true)
        vModel.logIn(email: emailTextField.text!, pass: passTextField.text!) { [weak self] success in
            guard let strSelf = self else {return}
            var message = ""
            if success {
                message = "Succesfully logged in"
                UserDefaults.standard.set(strSelf.emailTextField.text!, forKey: "email")
                strSelf.navigationController?.dismiss(animated: true)
            } else {
                message = "Oo no!"
            }
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                guard success else {return}
                let navigationController = UINavigationController(rootViewController: ChatListViewController())
                strSelf.view.window?.rootViewController = navigationController
            }))
            strSelf.display(alertController: alertController)
            DispatchQueue.main.async {
                strSelf.spinner.dismiss(animated: true)
            }
            
        }
    }
    @objc func goToRegister(){
        view.window?.rootViewController = RegisterViewController()
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
        view.addSubview(googleSignButton)
        
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
        googleSignButton.snp.makeConstraints { make in
            make.top.equalTo(regButton.snp.bottom).offset(20)
            make.height.equalTo(25)
            make.left.equalToSuperview().offset(70)
            make.right.equalToSuperview().offset(-70)
            
        }
        
    }
    
    
}
