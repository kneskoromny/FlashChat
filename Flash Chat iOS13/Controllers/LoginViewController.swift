//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    private let viewModel = LoginViewModel()
    
    // MARK: - UI Actions
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text,
           let password = passwordTextfield.text {
            
            viewModel.login(with: email, and: password) { [weak self] result in
                
                switch result {
                case .failure:
                    // TODO: make alert
                    print("Login error")
                case .success:
                    self?.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
            
        }
    }
    
}


