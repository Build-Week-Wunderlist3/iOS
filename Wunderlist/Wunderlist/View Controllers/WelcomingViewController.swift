//
//  WelcomingViewController.swift
//  Wunderlist
//
//  Created by Bohdan Tkachenko on 6/18/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import UIKit

class WelcomingViewController: UIViewController {
    
    //MARK: Properties
    private let buttonBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    
    //MARK: Outlets
    
    @IBOutlet var welcomLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    //MARK: Actions
    private func setupViews() {
        signupButton.layer.cornerRadius = 5.0
        loginButton.layer.cornerRadius = 5.0
        signupButton.layer.borderWidth = 1.0
        loginButton.layer.borderWidth = 1.0
        signupButton.layer.borderColor = buttonBorderColor.cgColor
        loginButton.layer.borderColor = buttonBorderColor.cgColor
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToLogInVC" {
            if let detailVC = segue.destination as? SignUpViewController {
                detailVC.title = "Log In"
                detailVC.loginType = LoginType.signIn
             // detailVC.logButton.setTitle("LogIn", for: .normal) ASK!!!!!!!
            }
            
            
        }
        
    }
}
