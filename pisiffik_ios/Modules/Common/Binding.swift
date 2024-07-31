//
//  Binding.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
    
}
