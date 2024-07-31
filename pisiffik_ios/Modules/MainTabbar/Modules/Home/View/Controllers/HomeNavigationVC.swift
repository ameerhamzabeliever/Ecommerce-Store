//
//  HomeNavigationVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 29/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class HomeNavigationVC: UINavigationController{
    
    //MARK: - OUTLET -
    
    
    //MARK: - PROPERTIES -
    
    
    
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
        self.tabBarItem.title = PisiffikStrings.home()
    }
    
    func setUI() {
        
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    
    //MARK: - ACTIONS -
    
    
    
}
