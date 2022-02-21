//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    private let viewModel = ChatViewModel()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        title = viewModel.title.value
        navigationItem.hidesBackButton = true
        
        // custom cell register
        tableView.register(
            UINib(nibName: K.cellNibName, bundle: Bundle.main), forCellReuseIdentifier: K.cellIdentifier
        )
        
        // bind properties
        viewModel.message.bind { [weak self] message in
            self?.messageTextfield.text = message
        }
        viewModel.messages.bind { [weak self] messages in
            print(#function, "Current Thread: \(Thread.current)")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        // fetch data
        viewModel.loadMessages { [weak self] result in
            switch result {
            case .failure:
                print("Ошибка при получении данных")
            case .success:
                self?.tableView.reloadData()
                self?.scrollToEnd()
            }
        }
    }
    
    // MARK: - UI Actions
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text,
           let messageSender = viewModel.userEmail {
            
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
    
    // MARK: - Methods
    private func scrollToEnd() {
        let indexPath = IndexPath(
            row: viewModel.messages.value.count - 1, section: 0
        )
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

// MARK: - Extensions
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.messages.value[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: K.cellIdentifier, for: indexPath
        ) as! MessageCell
        cell.label.text = message.body
        
        if message.sender == viewModel.userEmail {
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
