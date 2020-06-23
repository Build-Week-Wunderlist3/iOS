//
//  PasswordSetUp.swift
//  Wunderlist
//
//  Created by Bohdan Tkachenko on 6/18/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import Foundation
import UIKit

class SetupPasswordtextField {
    
 
    private var showHideButton: UIButton = UIButton()
    var textField = UITextField()
    
    var showPassword: Bool = true {
         didSet {
             textField.isSecureTextEntry = showPassword
             if showPassword {
                 showHideButton.setImage(UIImage(named: "eyes-closed.png"), for: .normal)
             } else {
                 showHideButton.setImage(UIImage(named: "eyes-open.png"), for: .normal)
             }
         }
     }
    
   
    
    @objc func showPasswordPressed() {
        showPassword.toggle()
            }
    
    func setupButton(textField: UITextField) {
   
      var showPassword: Bool = true {
          didSet {
              textField.isSecureTextEntry = showPassword
              if showPassword {
                  showHideButton.setImage(UIImage(named: "eyes-closed.png"), for: .normal)
              } else {
                  showHideButton.setImage(UIImage(named: "eyes-open.png"), for: .normal)
              }
          }
      }
    
     
   
           textField.rightView = showHideButton
           textField.rightViewMode = .always
           showHideButton.setImage(UIImage(named: "eyes-closed.png"), for: .normal)
           showHideButton.addTarget(self, action: #selector(showPasswordPressed), for: .touchUpInside)
           showHideButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
     
       
      
        
    }
}
