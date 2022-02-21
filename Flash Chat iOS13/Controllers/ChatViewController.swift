//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = []
    
    private let viewModel = ChatViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        title = viewModel.title.value
        navigationItem.hidesBackButton = true
        
        // для использования кастомной ячейки нужна регистрация
        tableView.register(
            UINib(nibName: K.cellNibName, bundle: Bundle.main), forCellReuseIdentifier: K.cellIdentifier
        )
        
        loadMessages()
        
        // bind properties
        viewModel.message.bind { [weak self] message in
            self?.messageTextfield.text = message
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text,
           let messageSender = Auth.auth().currentUser?.email {
            
            viewModel.send(
                message: messageBody, sender: messageSender
            ) { result in
                
                switch result {
                case .success:
                    print("Firebase saving success")
                case .failure:
                    // TODO: make alert
                    print("Firebase saving error")
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        viewModel.quit { [weak self] result in
            switch result {
            case .failure:
                print("Signing out error")
            case .success:
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func loadMessages() {
        viewModel.db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, err) in
                
            if let err = err {
                print("Ошибка при получении данных: \(err)")
            } else {
                self.messages = []
                
                if let snapshotDocuments = querySnapshot?.documents {
                    for snapshotDocument in snapshotDocuments {
                        let data = snapshotDocument.data()
                        if let sender = data[K.FStore.senderField] as? String,
                           let body = data[K.FStore.bodyField] as? String {
                            
                            let message = Message(sender: sender, body: body)
                            self.messages.append(message)
                            
                            self.tableView.reloadData()
                            // scroll to last element
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        }
                    }
                }
            }
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: K.cellIdentifier, for: indexPath
        ) as! MessageCell
        cell.label.text = message.body
        
        // проверяет кто отправитель сообщения и меняет UI
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftIV.isHidden = true
            cell.rightIV.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.leftIV.isHidden = false
            cell.rightIV.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        
        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}
