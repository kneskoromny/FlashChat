//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    private let viewModel = RegisterViewModel()
    
    // MARK: - UI Actions
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text,
           let password = passwordTextfield.text {
            
            viewModel.register(with: email, and: password) { [weak self] result in
                
                switch result {
                case .failure:
                    // TODO: make alert
                    print("Register error")
                case .success:
                    self?.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
    }
}
