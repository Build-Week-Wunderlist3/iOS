//
//  SignUpViewController.swift
//  Wunderlist
//
//  Created by Bohdan Tkachenko on 6/18/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    //MARK: Properties
    let passwordController = SetupPasswordtextField()
    
    
    
     //MARK: Outlets
    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var emailLabel: UITextField!
    @IBOutlet var usernameLabel: UITextField!
    @IBOutlet var passwordLabel: UITextField!
   
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordController.setupButton(textField: passwordLabel)
        
    }

    
    //MARK: Actions
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
