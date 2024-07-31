//
//  CancelOrderDoneVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 06/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class CancelOrderDoneVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var doneImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    var currentTitle : String = PisiffikStrings.requestSent()
    var currentDescription : String = PisiffikStrings.yourItemsHasBeenPlacedAndIsOnItWayToBeingProcessed()
    
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
        titleLbl.text = self.currentTitle
        descriptionLbl.text = self.currentDescription
        continueBtn.setTitle(PisiffikStrings._continue(), for: .normal)
    }
    
    func setUI() {
        titleLbl.font = Fonts.semiBoldFontsSize24
        titleLbl.textColor = .white
        descriptionLbl.font = Fonts.mediumFontsSize14
        descriptionLbl.textColor = .white
        continueBtn.titleLabel?.font = Fonts.mediumFontsSize16
        continueBtn.setTitleColor(.white, for: .normal)
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapContinueBtn(_ sender: UIButton){
        sender.showAnimation {
            RootRouter().loadMainTabbarScreens()
        }
    }
    
    
}
