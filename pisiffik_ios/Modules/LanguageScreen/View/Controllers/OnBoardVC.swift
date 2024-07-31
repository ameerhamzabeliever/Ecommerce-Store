//
//  OnBoardVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/05/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class OnBoardVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var coinTitleLbl: UILabel!
    @IBOutlet weak var coinDescriptionLbl: UILabel!
    @IBOutlet weak var loyalityTitleLbl: UILabel!
    @IBOutlet weak var loyalityDescriptionLbl: UILabel!
    @IBOutlet weak var walletTitleLbl: UILabel!
    @IBOutlet weak var walletDescriptionLbl: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    
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
        coinTitleLbl.text = "Optjen loyalitetspoint"
        coinDescriptionLbl.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit,sed do eiusmod tempor incididunt."
        loyalityTitleLbl.text = "Brug dine loyalitetspoint"
        loyalityDescriptionLbl.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit,sed do eiusmod tempor incididunt."
        walletTitleLbl.text = "Benyt dit medlemskort"
        walletDescriptionLbl.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit,sed do eiusmod tempor incididunt."
        continueBtn.setTitle(PisiffikStrings.next(), for: .normal)
    }
    
    func setUI() {
        coinTitleLbl.font = Fonts.semiBoldFontsSize18
        coinTitleLbl.textColor = R.color.textWhiteColor()
        coinDescriptionLbl.font = Fonts.mediumFontsSize12
        coinDescriptionLbl.textColor = R.color.textWhiteColor()
        loyalityTitleLbl.font = Fonts.semiBoldFontsSize18
        loyalityTitleLbl.textColor = R.color.textWhiteColor()
        loyalityDescriptionLbl.font = Fonts.mediumFontsSize12
        loyalityDescriptionLbl.textColor = R.color.textWhiteColor()
        walletTitleLbl.font = Fonts.semiBoldFontsSize18
        walletTitleLbl.textColor = R.color.textWhiteColor()
        walletDescriptionLbl.font = Fonts.mediumFontsSize12
        walletDescriptionLbl.textColor = R.color.textWhiteColor()
        continueBtn.titleLabel?.font = Fonts.mediumFontsSize14
        continueBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
        continueBtn.backgroundColor = R.color.lightGreenColor()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapContinueBtn(_ sender: UIButton) {
        sender.showAnimation {
            RootRouter().loadAuthenticationScreens()
//            guard let loginVC = R.storyboard.authSB.loginVC() else {return}
//            self.navigationController?.pushViewController(loginVC, animated: false)
        }
    }
    
    
}
