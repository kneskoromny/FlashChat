//
//  LoginViewModel.swift
//  Flash Chat iOS13
//
//  Created by Кирилл Нескоромный on 21.02.2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import Foundation
import Firebase

final class LoginViewModel {
    
    typealias FirAnswer = (K.Result) -> Void
    
    func login(
        with email: String, and password: String, completion: @escaping FirAnswer
    ) {
        Auth.auth().signIn(
            withEmail: email, password: password
        ) { authResult, error in
            
            if let e = error {
                print(e)
                completion(K.Result.failure)
            } else {
                completion(K.Result.success)
            }
        }
    }
}
