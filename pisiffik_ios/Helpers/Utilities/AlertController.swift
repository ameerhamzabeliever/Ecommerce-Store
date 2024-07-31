//
//  AlertController.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 09/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation
import UIKit

struct AlertController{
    
    static func showAlert(title: String, message: String,inVC: UIViewController,ok: @escaping () -> Void = { }){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: PisiffikStrings.ok(), style: .cancel) { _ in
            ok()
        }
        alert.addAction(okAction)
        inVC.present(alert, animated: true)
        
    }
    
}
