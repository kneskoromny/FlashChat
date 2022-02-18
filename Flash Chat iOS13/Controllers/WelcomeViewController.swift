//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = K.appName
        
//        titleLabel.text = ""
//        var charIndex = 0.0
//        let titleText = "⚡️FlashChat"
//        for char in titleText {
//            Timer.scheduledTimer(
//                withTimeInterval: 0.1 * charIndex, repeats: false
//            ) { [weak self] timer in
//
//                    self?.titleLabel.text?.append(char)
//                }
//            charIndex += 1
//        }
    
    }
    // MARK: - UI Actions
    @objc func typeText() {
        
    }

}
