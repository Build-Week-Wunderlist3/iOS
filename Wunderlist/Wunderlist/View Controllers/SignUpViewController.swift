//
//  SignUpViewController.swift
//  Wunderlist
//
//  Created by Bohdan Tkachenko on 6/18/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

enum LoginType {
    case signUp
    case signIn
}

class SignUpViewController: UIViewController {
    
    //MARK: Properties
    //Used with backend
    //let authenticaticationController = AuthenticaticationController()
    private var showHideButton: UIButton = UIButton()
    private let textFieldBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    var loginType = LoginType.signUp
    
    
    //MARK: Outlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var logButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    //MARK: Actions
    //Password Validation
    private func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    private func validateFields() -> String? {
        // Check all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Plese fill in all fields"
        }
        let cleanPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanPassword) == false {
            return "Please make sure your password is at least 8 characters, contains uppercase and lowercase alphabet and a number"
        }
        return nil
    }
    
    //Error Label Config
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
       //Validation
        let error = validateFields()
        if error != nil {
            showError(error!)
        } else {
            if let email = emailTextField.text, !email.isEmpty,
                let password = passwordTextField.text, !password.isEmpty {
                switch loginType {
                    //SignUp
                case .signUp:
                     self.showSpinner()
                    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                        if error != nil {
                            self.showError("Error creating user")
                        } else {
                            let db = Firestore.firestore()
                            db.collection("users").addDocument(data: ["email": email, "uuid": result!.user.uid]) { (error) in
                                if error != nil {
                                    self.showError("Error saving user data")
                                }
                            }
                            self.transitionToHome()
                        }
                    }
                    //SignIn
                case .signIn:
                     self.showSpinner()
                    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                        if error != nil {
                            self.showError(error!.localizedDescription)
                        } else {
                            self.transitionToHome()
                        }
                    }
              
                }
                
            }
        }
    }
    
    //MARK: Code used for backend built by web-student
    
    //        if let email = emailTextField.text, !email.isEmpty,
    //            let password = passwordTextField.text, !password.isEmpty {
    //            let user = User(username: email, password: password)
    //            switch loginType {
    //            case .signUp:
    //                authenticaticationController.register(with: user, completion: { (result) in
    //                    do {
    //                        let success = try result.get()
    //                        if success {
    //                            DispatchQueue.main.async {
    //                                let alertController = UIAlertController(title: "Welcom to Wunderland", message: "Wunderland 3.0", preferredStyle: .alert)
    //                                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    //                                alertController.addAction(alertAction)
    //                                self.present(alertController, animated: true) {
    //                                    self.loginType = .signIn
    //                                    self.navigationController?.title = "LogIn"
    //                                    self.logButton.setTitle("LogIn", for: .normal)
    //
    //                                }
    //                            }
    //                        }
    //                    } catch {
    //                        NSLog("Error sregister: \(error)")
    //                    }
    //                })
    //            case .signIn:
    //                authenticaticationController.signIn(with: user, completion: { (result) in
    //                    do {
    //                        let success = try result.get()
    //                        if success {
    //                            DispatchQueue.main.async {
    //                                self.dismiss(animated: true, completion: nil)
    //                            }
    //                        }
    //                    } catch {
    //                        if let error = error as? AuthenticaticationController.NetworkError {
    //                            switch error {
    //                            case .failedSignIn:
    //                                NSLog("SignIn failed")
    //                            case .noToken, .noData:
    //                                NSLog("No data recived")
    //                            default:
    //                                NSLog("Other error occured")
    //                            }
    //                        }
    //                    }
    //                })
    //            }
    //        }
    //    }
    
    private func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "WunderlistVC") as? TodoTableViewController
        self.navigationController?.pushViewController(homeViewController!, animated: true) //??
//        view.window?.rootViewController = homeViewController
//        view.window?.makeKeyAndVisible()
    }
    
    // SetUp Hide Button on PasswordTextField
    @objc func showPasswordPressed() {
        showPassword.toggle()
    }
    
    var showPassword: Bool = true {
        didSet {
            passwordTextField.isSecureTextEntry = showPassword
            if showPassword {
                showHideButton.setImage(UIImage(named: "eyes-closed.png"), for: .normal)
            } else {
                showHideButton.setImage(UIImage(named: "eyes-open.png"), for: .normal)
            }
        }
    }
    
    private func setupViews() {
        errorLabel.alpha = 0
        logButton.layer.cornerRadius = 25.0
        logButton.layer.borderWidth = 1.0
        logButton.layer.borderColor = textFieldBorderColor.cgColor
        passwordTextField.layer.cornerRadius = 5.0
        emailTextField.layer.cornerRadius = 5.0
        passwordTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = textFieldBorderColor.cgColor
        emailTextField.layer.borderColor = textFieldBorderColor.cgColor
        passwordTextField.rightView = showHideButton
        passwordTextField.rightViewMode = .always
        showHideButton.setImage(UIImage(named: "eyes-closed.png"), for: .normal)
        showHideButton.addTarget(self, action: #selector(showPasswordPressed), for: .touchUpInside)
        showHideButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    }
}
