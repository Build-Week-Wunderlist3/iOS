//
//  SignUpViewController.swift
//  Wunderlist
//
//  Created by Bohdan Tkachenko on 6/18/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class SignUpViewController: UIViewController {
    
    //MARK: Properties
    let authenticaticationController = AuthenticaticationController()
    private var showHideButton: UIButton = UIButton()
    private let textFieldBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    var loginType = LoginType.signUp
    
    
    //MARK: Outlets
    @IBOutlet var usernameLabel: UITextField!
    @IBOutlet var passwordLabel: UITextField!
    @IBOutlet var logButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    
    
    //MARK: Actions
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        self.showSpinner()
        if let username = usernameLabel.text, !username.isEmpty,
            let password = passwordLabel.text, !password.isEmpty {
            let user = User(username: username, password: password)
            switch loginType {
            case .signUp:
                authenticaticationController.register(with: user, completion: { (result) in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Welcom to Wunderland", message: "Wunderland 3.0", preferredStyle: .alert)
                                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(alertAction)
                                self.present(alertController, animated: true) {
                                    self.loginType = .signIn
                                    self.navigationController?.title = "LogIn"
                                    self.logButton.setTitle("LogIn", for: .normal)
                                    
                                }
                            }
                        }
                    } catch {
                        NSLog("Error sregister: \(error)")
                    }
                })
            case .signIn:
                authenticaticationController.signIn(with: user, completion: { (result) in
                    do {
                        let success = try result.get()
                        if success {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } catch {
                        if let error = error as? AuthenticaticationController.NetworkError {
                            switch error {
                            case .failedSignIn:
                                NSLog("SignIn failed")
                            case .noToken, .noData:
                                NSLog("No data recived")
                            default:
                                NSLog("Other error occured")
                            }
                        }
                    }
                })
            }
        }
    }
    // SetUp Hide Button on PasswordTextField
    @objc func showPasswordPressed() {
        showPassword.toggle()
    }
    
    var showPassword: Bool = true {
        didSet {
            passwordLabel.isSecureTextEntry = showPassword
            if showPassword {
                showHideButton.setImage(UIImage(named: "eyes-closed.png"), for: .normal)
            } else {
                showHideButton.setImage(UIImage(named: "eyes-open.png"), for: .normal)
            }
        }
    }
    
    private func setupViews() {
        logButton.layer.cornerRadius = 5.0
        logButton.layer.borderWidth = 1.0
        logButton.layer.borderColor = textFieldBorderColor.cgColor
        passwordLabel.layer.cornerRadius = 5.0
        usernameLabel.layer.cornerRadius = 5.0
        passwordLabel.layer.borderWidth = 1.0
        usernameLabel.layer.borderWidth = 1.0
        passwordLabel.layer.borderColor = textFieldBorderColor.cgColor
        usernameLabel.layer.borderColor = textFieldBorderColor.cgColor
        passwordLabel.rightView = showHideButton
        passwordLabel.rightViewMode = .always
        showHideButton.setImage(UIImage(named: "eyes-closed.png"), for: .normal)
        showHideButton.addTarget(self, action: #selector(showPasswordPressed), for: .touchUpInside)
        showHideButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToToDoVC" && authenticaticationController.bearer != nil {
            // inject dependencies
            if let loginVC = segue.destination as? TodoTableViewController {
                loginVC.authenticaticationController = authenticaticationController
            }
        }
    }
    
    
}
