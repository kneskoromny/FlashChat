//
//  RegisterViewModel.swift
//  Flash Chat iOS13
//
//  Created by Кирилл Нескоромный on 21.02.2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import Foundation
import Firebase

final class RegisterViewModel {
    
    typealias FirAnswer = (K.Result) -> Void
    
    func register(
        with email: String, and password: String, completion: @escaping FirAnswer
    ) {
        
        Auth.auth().createUser(
            withEmail: email, password: password
        ) { authResult, error in
            
            if let e = error {
                print(e)
                completion(K.Result.failure)
            } else {
                // navigate to the ChatVC
                completion(K.Result.success)
            }
        }
    }
}
