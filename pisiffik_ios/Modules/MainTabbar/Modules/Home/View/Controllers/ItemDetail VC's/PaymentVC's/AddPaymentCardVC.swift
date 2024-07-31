//
//  AddPaymentCardVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 16/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class AddPaymentCardVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cardNumberLbl: UILabel!
    @IBOutlet weak var cardNmbTextField: UITextField!
    @IBOutlet weak var expireMonthLbl: UILabel!
    @IBOutlet weak var expireMonthTextField: UITextField!
    @IBOutlet weak var expireYearLbl: UILabel!
    @IBOutlet weak var expireYearTextField: UITextField!
    @IBOutlet weak var securityCodeLbl: UILabel!
    @IBOutlet weak var securityCodeTextField: UITextField!
    @IBOutlet weak var saveCardBtn: UIButton!
    @IBOutlet weak var cvvInfoBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        cardNmbTextField.delegate = self
        securityCodeTextField.addTarget(self, action: #selector(didCVCTextFieldTextChanged(_:)), for: .editingChanged)
        expireMonthTextField.addTarget(self, action: #selector(didMonthTextFieldTextChanged(_:)), for: .editingChanged)
        expireYearTextField.addTarget(self, action: #selector(didYearTextFieldTextChanged(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.paymentMethod()
        nameLbl.text = PisiffikStrings.nameOnCard()
        cardNumberLbl.text = "\(PisiffikStrings.cardNumber()):"
        expireMonthLbl.text = "\(PisiffikStrings.expiryMonth()):"
        expireYearLbl.text = "\(PisiffikStrings.expiryYear()):"
        securityCodeLbl.text = PisiffikStrings.cvv()
        saveCardBtn.setTitle(PisiffikStrings.saveCard(), for: .normal)
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
        nameLbl.font = Fonts.mediumFontsSize14
        nameLbl.textColor = R.color.textBlackColor()
        cardNumberLbl.font = Fonts.mediumFontsSize14
        cardNumberLbl.textColor = R.color.textBlackColor()
        cardNmbTextField.font = Fonts.regularFontsSize14
        expireMonthLbl.font = Fonts.mediumFontsSize14
        expireMonthLbl.textColor = R.color.textBlackColor()
        expireMonthTextField.font = Fonts.regularFontsSize14
        expireYearLbl.font = Fonts.mediumFontsSize14
        expireYearLbl.textColor = R.color.textBlackColor()
        expireYearTextField.font = Fonts.regularFontsSize14
        securityCodeLbl.font = Fonts.mediumFontsSize14
        securityCodeLbl.textColor = R.color.textBlackColor()
        securityCodeTextField.font = Fonts.regularFontsSize14
        saveCardBtn.titleLabel?.font = Fonts.mediumFontsSize16
        saveCardBtn.setTitleColor(R.color.textWhiteColor(), for: .normal)
        saveCardBtn.backgroundColor = R.color.darkBlueColor()
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
    
    @IBAction func didTapSaveCardBtn(_ sender: UIButton) {
        sender.showAnimation {
            guard let cardsVC = R.storyboard.homeSB.paymentCardsVC() else {return}
            cardsVC.mode = .fromAddCard
            self.push(controller: cardsVC, hideBar: true, animated: true)
        }
    }
    
    @IBAction func didTapCVVInfoBtn(_ sender: UIButton) {
        sender.showAnimation {
            
        }
    }
    
    
    
}

//MARK: - EXTENSION FOR MONTH/YEAR/CVC VALIDATION -

extension AddPaymentCardVC{
    
    @objc func didCVCTextFieldTextChanged(_ textField: UITextField){
        guard let text = textField.text else { return }
        if text.isContainOnlyNumber == false{
            if text.isEmpty == false{
                self.securityCodeTextField.text?.removeLast()
            }
        }else if text.count > 4{
            self.securityCodeTextField.text?.removeLast()
        }
    }
    
    @objc func didMonthTextFieldTextChanged(_ textField: UITextField){
        guard let text = textField.text else { return }
        if text.isContainOnlyNumber == false{
            if text.isEmpty == false{
                self.expireMonthTextField.text?.removeLast()
            }
        }else{
            if text.count > 2{
                self.expireMonthTextField.text?.removeLast()
            }else{
                if text.toInt() > 12 {
                    self.expireMonthTextField.text?.removeLast()
                }
            }
        }
    }
    
    @objc func didYearTextFieldTextChanged(_ textField: UITextField){
        guard let text = textField.text else { return }
        if text.isContainOnlyNumber == false{
            if text.isEmpty == false{
                self.expireYearTextField.text?.removeLast()
            }
        }else{
            if text.count > 2{
                self.expireYearTextField.text?.removeLast()
            } else if text.count == 2{
                var components = DateComponents()
                components.calendar = Calendar.current
                let year = Calendar.current.component(.year, from: Date())
                if text.toInt() < (year % 100) {
                    self.expireYearTextField.text?.removeAll()
                }
            }
        }
    }
    
}


//MARK: - EXTENSION FOR DEBIT/CREDIT CARD VALIDATION -

extension AddPaymentCardVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String
        
        if cardNmbTextField == textField {
            textField.text = lastText.format("nnnn nnnn nnnn nnnn", oldString: text)
            return false
        }
                               
        return true
    }
}
