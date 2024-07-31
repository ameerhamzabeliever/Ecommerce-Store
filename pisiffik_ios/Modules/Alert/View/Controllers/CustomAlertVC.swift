//
//  CustomAlertVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 28/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

protocol CustomAlertDelegates {
    func didTapOnDoneBtn(at index: Int)
}

class CustomAlertVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    var delegate: CustomAlertDelegates?
    var currentIndex : Int = -1
    var currentTitle : String = PisiffikStrings.deleteAddress()
    var currentDescription : String = PisiffikStrings.areYouSureYouWantToDeleteThisAddress()
    var doneBtnTitle : String = PisiffikStrings.yes()
    var cancelBtnTitle : String = PisiffikStrings.no()
    
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
        self.titleLbl.text = self.currentTitle
        self.descriptionLbl.text = self.currentDescription
        self.yesBtn.setTitle(self.doneBtnTitle, for: .normal)
        self.noBtn.setTitle(self.cancelBtnTitle, for: .normal)
    }
    
    func setUI() {
        titleLbl.font = Fonts.semiBoldFontsSize20
        titleLbl.textColor = R.color.textBlackColor()
        descriptionLbl.font = Fonts.mediumFontsSize14
        descriptionLbl.textColor = R.color.textGrayColor()
        yesBtn.titleLabel?.font = Fonts.mediumFontsSize16
        yesBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
        yesBtn.backgroundColor = R.color.textWhiteColor()
        noBtn.titleLabel?.font = Fonts.mediumFontsSize16
        noBtn.setTitleColor(R.color.textWhiteColor(), for: .normal)
        noBtn.backgroundColor = R.color.darkBlueColor()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapYesBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.delegate?.didTapOnDoneBtn(at: self.currentIndex)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapNoBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
