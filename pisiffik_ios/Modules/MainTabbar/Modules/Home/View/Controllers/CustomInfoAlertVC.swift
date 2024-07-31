//
//  CustomInfoAlertVC.swift
//  pisiffik_ios
//
//  Created by APPLE on 6/17/22.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class CustomInfoAlertVC: BaseVC {
    
    //MARK: - OUTLETS -
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    //MARK: - PROPERTIES -
    
    var alertTitle : String = ""
    var alertDescription: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
    
    //MARK: - LIFE CYCLE -
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - METHODS -
    @objc func setText(){
        titleLbl.text = alertTitle
        descriptionLbl.text = alertDescription
    }
    
    func setUI() {
        titleLbl.font = Fonts.semiBoldFontsSize20
        titleLbl.textColor = R.color.textBlackColor()
        descriptionLbl.font = Fonts.mediumFontsSize14
        descriptionLbl.textColor = R.color.textGrayColor()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapCancelBtn(_ sender: UIButton){
        sender.showAnimation {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
