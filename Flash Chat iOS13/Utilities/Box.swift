//
//  Box.swift
//  Flash Chat iOS13
//
//  Created by Кирилл Нескоромный on 21.02.2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import Foundation

final class Box<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
