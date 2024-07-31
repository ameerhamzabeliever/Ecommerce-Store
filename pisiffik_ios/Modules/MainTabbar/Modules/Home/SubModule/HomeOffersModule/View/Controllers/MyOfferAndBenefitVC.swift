//
//  MyOfferAndBenefitVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 20/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import SYBadgeButton

enum MyOfferAndBenefitMode{
    case fromHome
    case fromProfile
    case forPersonal
    case forLocal
    case forMembership
}

class MyOfferAndBenefitVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cartBtn: SYBadgeButton!
    @IBOutlet weak var personalLbl: UILabel!
    @IBOutlet weak var personalView: UIView!
    @IBOutlet weak var personalBtn: UIButton!{
        didSet{
            personalBtn.tintColor = .clear
        }
    }
    @IBOutlet weak var localLbl: UILabel!
    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var localBtn: UIButton!{
        didSet{
            localBtn.tintColor = .clear
        }
    }
    @IBOutlet weak var membershipLbl: UILabel!
    @IBOutlet weak var membershipView: UIView!
    @IBOutlet weak var membershipBtn: UIButton!{
        didSet{
            membershipBtn.tintColor = .clear
        }
    }
    
    //MARK: - PROPERTIES -
    
    var offerTabs: MyOfferAndBenefitContainerVC?
    
    var mode : MyOfferAndBenefitMode = {
        let mode : MyOfferAndBenefitMode = .fromProfile
        return mode
    }()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        setCurrentOffersOf(type: .personal)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartBtn.badgeValue = Utils.shared.getShoppingList(count: UserDefault.shared.getCartListCount())
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.offersAndBenefits()
        personalLbl.text = PisiffikStrings.personal()
        localLbl.text = PisiffikStrings.local()
        membershipLbl.text = PisiffikStrings.membership()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        personalLbl.font = Fonts.semiBoldFontsSize16
        localLbl.font = Fonts.semiBoldFontsSize16
        membershipLbl.font = Fonts.semiBoldFontsSize16
        setInboxTab()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    func setInboxTab(){
        guard let offerTabs = self.children.first as? MyOfferAndBenefitContainerVC else {return}
        self.offerTabs = offerTabs
        offerTabs.mode = self.mode
        offerTabs.setSelectedTab = { (index, value) in
            switch index{
            case 0:
                self.setCurrentOffersOf(type: .personal)
            case 1:
                self.setCurrentOffersOf(type: .local)
            case 2:
                self.setCurrentOffersOf(type: .memberships)
            default:
                Constants.printLogs("........")
            }
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapCartBtn(_ sender: UIButton){
        sender.showAnimation {
            guard let myCartVC = R.storyboard.homeSB.myCartVC() else {return}
            self.push(controller: myCartVC, hideBar: true, animated: true)
        }
    }
    
    @IBAction func didTapInboxBtns(_ sender: UIButton){
        switch sender.tag{
        case 0:
            setCurrentOffersOf(type: .personal)
            offerTabs?.mode = .forPersonal
        case 1:
            setCurrentOffersOf(type: .local)
            offerTabs?.mode = .forLocal
        case 2:
            setCurrentOffersOf(type: .memberships)
            offerTabs?.mode = .forMembership
        default:
            Constants.printLogs("........")
        }
    }
    
}


//MARK: - EXTENSION FOR CONTAINER VIEWS SETUP -

extension MyOfferAndBenefitVC{
    
    fileprivate func setCurrentOffersOf(type: MyOfferBenefitType){
        
        switch type {
        case .personal:
            
            self.personalBtn.isSelected = true
            self.localBtn.isSelected = false
            self.membershipBtn.isSelected = false
            self.personalLbl.textColor = R.color.lightBlueColor()
            self.localLbl.textColor = R.color.darkGrayColor()
            self.membershipLbl.textColor = R.color.darkGrayColor()
            self.personalView.backgroundColor = R.color.lightBlueColor()
            self.localView.backgroundColor = .white
            self.membershipView.backgroundColor = .white
            setPeronsalVC()
            
        case .local:
            
            self.personalBtn.isSelected = false
            self.localBtn.isSelected = true
            self.membershipBtn.isSelected = false
            self.personalLbl.textColor = R.color.darkGrayColor()
            self.localLbl.textColor = R.color.lightBlueColor()
            self.membershipLbl.textColor = R.color.darkGrayColor()
            self.personalView.backgroundColor = .white
            self.localView.backgroundColor = R.color.lightBlueColor()
            self.membershipView.backgroundColor = .white
            setLocalVC()
            
        case .memberships:
            
            self.personalBtn.isSelected = false
            self.localBtn.isSelected = false
            self.membershipBtn.isSelected = true
            self.personalLbl.textColor = R.color.darkGrayColor()
            self.localLbl.textColor = R.color.darkGrayColor()
            self.membershipLbl.textColor = R.color.lightBlueColor()
            self.personalView.backgroundColor = .white
            self.localView.backgroundColor = .white
            self.membershipView.backgroundColor = R.color.lightBlueColor()
            setMembershipVC()
            
        }
        
    }
    
}



//MARK: - EXTENSION FOR NAVIGATION FUNC -

extension MyOfferAndBenefitVC {
    
    func setPeronsalVC() {
        offerTabs?.setViewContollerAtIndex(index: 0, animate: false)
    }
    
    func setLocalVC() {
        offerTabs?.setViewContollerAtIndex(index: 1, animate: false)
    }
    
    func setMembershipVC() {
        offerTabs?.setViewContollerAtIndex(index: 2, animate: false)
    }
    
}
