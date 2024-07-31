//
//  BaseVC.swift
//  pisiffik-ios
//
//  Created by Haider Ali on 23/05/2022.
//  Copyright © 2022 softwarealliance.dk. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    var popRecognizer: InteractivePopRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        implementSwipeToPop()
        setInteractiveRecognizer()
        // Do any additional setup after loading the view.
    }
    
    @objc func popToDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func implementSwipeToPop() {
        
        let gestureRec = UISwipeGestureRecognizer(target: self, action: #selector(popToDismiss))
        gestureRec.direction = .right
        self.view.addGestureRecognizer(gestureRec)
        
    }
    
    private func setInteractiveRecognizer() {
        guard let controller = navigationController else { return }
        popRecognizer = InteractivePopRecognizer(controller: controller)
        controller.interactivePopGestureRecognizer?.delegate = popRecognizer
    }

}
