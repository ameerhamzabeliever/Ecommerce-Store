//
//  LanguageVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/05/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import Localize_Swift

class LanguageVC: UIViewController {

    //MARK: - OUTLET -
    
    @IBOutlet weak var selectLanguageLbl: UILabel!
    @IBOutlet weak var continueBtn: LoadingButton!
    @IBOutlet weak var danishSelectIcon: UIImageView!
    @IBOutlet weak var germanSelectIcon: UIImageView!
    @IBOutlet weak var englishSelectIcon: UIImageView!
    @IBOutlet weak var danishLbl: UILabel!
    @IBOutlet weak var kalaallisutLbl: UILabel!
    @IBOutlet weak var englishLbl: UILabel!
    @IBOutlet weak var danishBgView: UIView!
    @IBOutlet weak var kalaallisutBgView: UIView!
    @IBOutlet weak var englishBgView: UIView!
    
    //MARK: - PROPERTIES -
    
    var mode : LanguageMode = {
        let mode : LanguageMode = .fromSignUp
        return mode
    }()
    
    var currentLangType : LanguageSelection = {
        let type : LanguageSelection = .dansk
        return type
    }()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        if mode == .fromMyProfile{
            getCurrentLanguage()
        }else{
            self.didSelectLangaugeOf(type: .dansk)
        }
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -

    @objc func setText(){
        selectLanguageLbl.text = PisiffikStrings.pleaseSelectYourLanguage()
        danishLbl.text = PisiffikStrings.danish()
        kalaallisutLbl.text = PisiffikStrings.greenland()
        englishLbl.text = PisiffikStrings.english()
        continueBtn.setTitle(PisiffikStrings._continue(), for: .normal)
    }
    
    func setUI() {
        selectLanguageLbl.font = Fonts.regularFontsSize12
        selectLanguageLbl.textColor = .white
        danishLbl.font = Fonts.mediumFontsSize16
        danishLbl.textColor = .white
        kalaallisutLbl.font = Fonts.mediumFontsSize16
        kalaallisutLbl.textColor = .white
        englishLbl.font = Fonts.mediumFontsSize16
        englishLbl.textColor = .white
        continueBtn.titleLabel?.font = Fonts.mediumFontsSize14
        continueBtn.setTitleColor(R.color.darkFontColor(), for: .normal)
        continueBtn.backgroundColor = R.color.darkGrayColor()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    private func didSelectLangaugeOf(type: LanguageSelection){
        
        self.enableContinueBtn()
        self.setLanguageByTap(type: type)
        
        if type == .dansk{
            
            self.danishBgView.backgroundColor = R.color.backgroundColor()
            self.danishLbl.textColor = R.color.textBlackColor()
            self.danishSelectIcon.image = R.image.ic_blue_circle()
            self.kalaallisutBgView.backgroundColor = .clear
            self.kalaallisutLbl.textColor = R.color.textWhiteColor()
            self.germanSelectIcon.image = R.image.ic_uncheck_circle()
            self.englishBgView.backgroundColor = .clear
            self.englishLbl.textColor = R.color.textWhiteColor()
            self.englishSelectIcon.image = R.image.ic_uncheck_circle()
            currentLangType = .dansk
            
        }else if type == .greenland{
            
            self.danishBgView.backgroundColor = .clear
            self.danishLbl.textColor = R.color.textWhiteColor()
            self.danishSelectIcon.image = R.image.ic_uncheck_circle()
            self.kalaallisutBgView.backgroundColor = R.color.backgroundColor()
            self.kalaallisutLbl.textColor = R.color.textBlackColor()
            self.germanSelectIcon.image = R.image.ic_blue_circle()
            self.englishBgView.backgroundColor = .clear
            self.englishLbl.textColor = R.color.textWhiteColor()
            self.englishSelectIcon.image = R.image.ic_uncheck_circle()
            currentLangType = .greenland
            
        }else if type == .english{
            
            self.danishBgView.backgroundColor = .clear
            self.danishLbl.textColor = R.color.textWhiteColor()
            self.danishSelectIcon.image = R.image.ic_uncheck_circle()
            self.kalaallisutBgView.backgroundColor = .clear
            self.kalaallisutLbl.textColor = R.color.textWhiteColor()
            self.germanSelectIcon.image = R.image.ic_uncheck_circle()
            self.englishBgView.backgroundColor = R.color.backgroundColor()
            self.englishLbl.textColor = R.color.textBlackColor()
            self.englishSelectIcon.image = R.image.ic_blue_circle()
            currentLangType = .english
            
        }
        
    }
    
    private func enableContinueBtn(){
        self.continueBtn.isEnabled = true
        self.continueBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
        self.continueBtn.backgroundColor = R.color.lightGreenColor()
    }
    
    private func getCurrentLanguage(){
        if Localize.currentLanguage() == .danish{
            self.didSelectLangaugeOf(type: .dansk)
        }else if Localize.currentLanguage() == .greenland{
            self.didSelectLangaugeOf(type: .greenland)
        }else{
            self.didSelectLangaugeOf(type: .english)
        }
    }
    
    private func saveCurrentLanguage(type: LanguageSelection){
        switch type {
        case .dansk:
            Localize.setCurrentLanguage(.danish)
        case .greenland:
            Localize.setCurrentLanguage(.greenland)
        case .english:
            Localize.setCurrentLanguage(.english)
        }
    }
    
    
    //MARK: - ACTIONS -
    
    
    @IBAction func didTapSelectLanguageBtn(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            self.didSelectLangaugeOf(type: .dansk)
        case 1:
            self.didSelectLangaugeOf(type: .greenland)
        case 2:
            self.didSelectLangaugeOf(type: .english)
        default:
            break
        }
    }
    
    
    @IBAction func didTapContinueBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.saveCurrentLanguage(type: self.currentLangType)
            if self.mode == .fromMyProfile{
                RootRouter().loadMainTabbarScreens()
            }else{
                guard let onBoardVC = R.storyboard.languageBoard.onBoardVC() else {return}
                self.navigationController?.pushViewController(onBoardVC, animated: true)
            }
        }
    }
    

}


//MARK: - EXTENSION FOR TAP LANGUAGE -

extension LanguageVC{
    
    private func setLanguageByTap(type: LanguageSelection){
        switch type {
        case .dansk:
            selectLanguageLbl.text = "Vælg venligst sprog"
            danishLbl.text = "Dansk"
            kalaallisutLbl.text = "Grønlandsk"
            englishLbl.text = "Engelsk"
            continueBtn.setTitle("Fortsæt", for: .normal)
            
        case .greenland:
            selectLanguageLbl.text = "Oqaatsit atorniakkatit toqqakkit"
            danishLbl.text = "Danskisut"
            kalaallisutLbl.text = "Kalaallisut"
            englishLbl.text = "Tuluttut"
            continueBtn.setTitle("Ingerlaqqigit", for: .normal)
            
        case .english:
            selectLanguageLbl.text = "Please Select Your Language"
            danishLbl.text = "Danish"
            kalaallisutLbl.text = "Greenland"
            englishLbl.text = "English"
            continueBtn.setTitle("Continue", for: .normal)
            
        }
    }
    
}
