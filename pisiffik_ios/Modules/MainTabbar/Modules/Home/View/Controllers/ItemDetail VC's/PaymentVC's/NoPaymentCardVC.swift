//
//  NoPaymentCardVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 16/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class NoPaymentCardVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var noCardsLbl: UILabel!
    @IBOutlet weak var addACardToLbl: UILabel!
    @IBOutlet weak var addCardBtn: UIButton!
    
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
        titleLbl.text = PisiffikStrings.paymentMethod()
        noCardsLbl.text = PisiffikStrings.noCardsAdded()
        addACardToLbl.text = PisiffikStrings.addACardToEnjoyASeamlessPaymentsExperience()
        addCardBtn.setTitle(PisiffikStrings.addNewCard(), for: .normal)
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
        noCardsLbl.font = Fonts.mediumFontsSize24
        noCardsLbl.textColor = R.color.textBlackColor()
        addACardToLbl.font = Fonts.mediumFontsSize14
        addACardToLbl.textColor = R.color.textGrayColor()
        addCardBtn.titleLabel?.font = Fonts.mediumFontsSize16
        addCardBtn.setTitleColor(R.color.textWhiteColor(), for: .normal)
        addCardBtn.backgroundColor = R.color.darkBlueColor()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapAddCardBtn(_ sender: UIButton){
        sender.showAnimation {
            guard let addPaymentCardVC = R.storyboard.homeSB.addPaymentCardVC() else {return}
            self.push(controller: addPaymentCardVC, hideBar: true, animated: true)
        }
    }
    
}
