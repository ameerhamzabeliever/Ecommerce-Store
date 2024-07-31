//
//  AddAddressVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 28/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import ActiveLabel

class AddAddressVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var stateBtn: UIButton!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityBtn: UIButton!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var officeView: UIView!
    @IBOutlet weak var officeBtn: UIButton!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var instructionLbl: ActiveLabel!
    @IBOutlet weak var instructionTextField: UITextField!
    
    
    //MARK: - PROPERTIES -
    
    var mode : AddAddressMode = {
        let mode : AddAddressMode = .none
        return mode
    }()
    
    let addressFieldPlaceholder : String = "1227 Tawny Nectar Nook"
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        setAddressOf(type: mode)
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.editAddress()
        countryLbl.text = PisiffikStrings.country()
        stateLbl.text = PisiffikStrings.state()
        cityLbl.text = PisiffikStrings.city()
        addressLbl.text = PisiffikStrings.address()
        typeLbl.text = PisiffikStrings.type()
        homeBtn.setTitle(PisiffikStrings.home(), for: .normal)
        officeBtn.setTitle(PisiffikStrings.office(), for: .normal)
        otherBtn.setTitle(PisiffikStrings.other(), for: .normal)
        instructionLbl.text = "\(PisiffikStrings.instructions()) \(PisiffikStrings.optional())"
        saveBtn.setTitle(PisiffikStrings.saveChanges(), for: .normal)
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
        countryLbl.font = Fonts.mediumFontsSize14
        countryLbl.textColor = R.color.textBlackColor()
        stateLbl.font = Fonts.mediumFontsSize14
        stateLbl.textColor = R.color.textBlackColor()
        cityLbl.font = Fonts.mediumFontsSize14
        cityLbl.textColor = R.color.textBlackColor()
        addressLbl.font = Fonts.mediumFontsSize14
        addressLbl.textColor = R.color.textBlackColor()
        typeLbl.font = Fonts.mediumFontsSize14
        typeLbl.textColor = R.color.textBlackColor()
        homeBtn.titleLabel?.font = Fonts.mediumFontsSize14
        officeBtn.titleLabel?.font = Fonts.mediumFontsSize14
        otherBtn.titleLabel?.font = Fonts.mediumFontsSize14
        instructionLbl.font = Fonts.mediumFontsSize14
        instructionLbl.textColor = R.color.textGrayColor()
        saveBtn.titleLabel?.font = Fonts.mediumFontsSize16
        saveBtn.setTitleColor(R.color.textWhiteColor(), for: .normal)
        saveBtn.backgroundColor = R.color.darkBlueColor()
        setActiveLabel()
        // In Case Of No Address....
        addressTextView.text = self.addressFieldPlaceholder
        addressTextView.textColor = R.color.textLightGrayColor()
        addressTextView.delegate = self
        self.deleteBtn.isHidden = true
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func setActiveLabel(){
        let instructionType = ActiveType.custom(pattern: "\(PisiffikStrings.instructions())")
        self.instructionLbl.enabledTypes = [instructionType]
        self.instructionLbl.customColor[instructionType] = R.color.textBlackColor()
    }
    
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapSaveBtn(_ sender: UIButton){
        sender.showAnimation {
            
        }
    }
    
    @IBAction func didTapDeleteBtn(_ sender: UIButton){
        sender.showAnimation {
            
        }
    }
    
    @IBAction func didTapCountryBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapStateBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapCityBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func didTapAddressTypeBtns(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            self.setAddressOf(type: .home)
        case 1:
            self.setAddressOf(type: .office)
        case 2:
            self.setAddressOf(type: .other)
        default:
            Constants.printLogs("*******")
        }
    }
    
    
}

//MARK: - EXTENSION FOR TEXT VIEW DELEGATES -

extension AddAddressVC: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if addressTextView.textColor == R.color.textLightGrayColor() {
            addressTextView.text = ""
            addressTextView.textColor = R.color.textBlackColor()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if addressTextView.text == "" {
            addressTextView.text = self.addressFieldPlaceholder
            addressTextView.textColor = R.color.textLightGrayColor()
        }
    }
    
}


//MARK: - EXTENSION FOR ADD ADDRESS TYPE FUNC -

extension AddAddressVC{
    
    private func setAddressOf(type: AddAddressMode){
        switch type {
        case .home:
            
            self.homeView.backgroundColor = R.color.lightBlueColor()
            self.officeView.backgroundColor = R.color.textWhiteColor()
            self.otherView.backgroundColor = R.color.textWhiteColor()
            self.homeBtn.setTitleColor(R.color.textWhiteColor(), for: .normal)
            self.officeBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
            self.otherBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
            self.homeBtn.tintColor = R.color.textWhiteColor()
            self.officeBtn.tintColor = R.color.textBlackColor()
            self.otherBtn.tintColor = R.color.textBlackColor()
            
        case .office:
            
            self.homeView.backgroundColor = R.color.textWhiteColor()
            self.officeView.backgroundColor = R.color.lightBlueColor()
            self.otherView.backgroundColor = R.color.textWhiteColor()
            self.homeBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
            self.officeBtn.setTitleColor(R.color.textWhiteColor(), for: .normal)
            self.otherBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
            self.homeBtn.tintColor = R.color.textBlackColor()
            self.officeBtn.tintColor = R.color.textWhiteColor()
            self.otherBtn.tintColor = R.color.textBlackColor()
            
        case .other:
            
            self.homeView.backgroundColor = R.color.textWhiteColor()
            self.officeView.backgroundColor = R.color.textWhiteColor()
            self.otherView.backgroundColor = R.color.lightBlueColor()
            self.homeBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
            self.officeBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
            self.otherBtn.setTitleColor(R.color.textWhiteColor(), for: .normal)
            self.homeBtn.tintColor = R.color.textBlackColor()
            self.officeBtn.tintColor = R.color.textBlackColor()
            self.otherBtn.tintColor = R.color.textWhiteColor()
            
        case .none:
            
            self.homeView.backgroundColor = R.color.textWhiteColor()
            self.officeView.backgroundColor = R.color.textWhiteColor()
            self.otherView.backgroundColor = R.color.textWhiteColor()
            self.homeBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
            self.officeBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
            self.otherBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
            self.homeBtn.tintColor = R.color.textBlackColor()
            self.officeBtn.tintColor = R.color.textBlackColor()
            self.otherBtn.tintColor = R.color.textBlackColor()
            
        }
    }
    
}
