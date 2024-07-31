//
//  VerificationDoneVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 30/05/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class VerificationDoneVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var okLbl: UILabel!
    
    //MARK: - PROPERTIES -
    
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            RootRouter().loadMainTabbarScreens()
        }
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        okLbl.text = PisiffikStrings.ok()
    }
    
    func setUI() {
        okLbl.font = Fonts.semiBoldFontsSize24
        okLbl.textColor = .white
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    //MARK: - ACTIONS -
    
    
    
}
