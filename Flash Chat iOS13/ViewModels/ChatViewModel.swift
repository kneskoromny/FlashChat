//
//  ChatViewModel.swift
//  Flash Chat iOS13
//
//  Created by Кирилл Нескоромный on 21.02.2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import Foundation
import Firebase

final class ChatViewModel {
    
    typealias FirAnswer = (K.Result) -> Void
    
    let db = Firestore.firestore()
    
    var userEmail: String? {
        get {
            Auth.auth().currentUser?.email
        }
    }
    
    // MARK: - Binded properties
    let title = Box(K.appName)
    let message = Box("")
    let messages: Box<[Message]> = Box([])
    
    
    func quit(completion: @escaping FirAnswer) {
        do {
            try Auth.auth().signOut()
            completion(K.Result.success)
        } catch let e {
            print(e)
            completion(K.Result.failure)
        }
    }
    
    func send(
        message: String, sender: String, completion: @escaping FirAnswer
    ) {
        
        db.collection(K.FStore.collectionName).addDocument(
            data: [
                K.FStore.senderField: sender,
                K.FStore.bodyField: message,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]
        ) { error in
            if let e = error {
                print(e)
                completion(K.Result.failure)
            } else {
                completion(K.Result.success)
                self.message.value = ""
            }
        }
    }
    
    func loadMessages(completion: @escaping FirAnswer) {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                
            if let e = error {
                print(e)
                completion(K.Result.failure)
            } else {
                self.messages.value = []
                
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    for snapshotDocument in snapshotDocuments {
                        let data = snapshotDocument.data()
                        if let sender = data[K.FStore.senderField] as? String,
                           let body = data[K.FStore.bodyField] as? String {
                            
                            let message = Message(sender: sender, body: body)
                            self.messages.value.append(message)
                        }
                    }
                    completion(K.Result.success)
                }
            }
        }
    }
}
