//
//  ForgotPasswordVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 01/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import PhoneNumberKit

class ForgotPasswordVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var fogotPasswordLbl: UILabel!
    @IBOutlet weak var enterMobileLbl: UILabel!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var phoneNumberTextField: PhoneNumberTextField!
    @IBOutlet weak var continueBtn: LoadingButton!
    
    private var getPhoneNmb : String{
        return "+\(phoneNumberTextField.phoneNumber?.countryCode ?? 123)\(phoneNumberTextField.phoneNumber?.nationalNumber ?? 456)"
    }
    
    //MARK: - PROPERTIES -
    
    var viewModel : ForgotPasswordViewModel = ForgotPasswordViewModel()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        configurePhoneNumberKit()
        self.viewModel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if phoneNumberTextField.isValidNumber{
//            continueBtn.isEnabled = true
//        }else{
//            continueBtn.isEnabled = false
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationBarShould(hidden: true)
    }
    
    //MARK: - METHODS -
    
    @objc func setText(){
        fogotPasswordLbl.text = PisiffikStrings.forgot_Password()
        enterMobileLbl.text = PisiffikStrings.enterYourMobileNumberToResetPassword()
        mobileNumberLbl.text = PisiffikStrings.mobileNumber()
        continueBtn.setTitle(PisiffikStrings._continue(), for: .normal)
    }
    
    func setUI() {
        fogotPasswordLbl.font = Fonts.semiBoldFontsSize24
        fogotPasswordLbl.textColor = R.color.textWhiteColor()
        enterMobileLbl.font = Fonts.mediumFontsSize14
        enterMobileLbl.textColor = R.color.textWhiteColor()
        mobileNumberLbl.font = Fonts.mediumFontsSize14
        mobileNumberLbl.textColor = R.color.textWhiteColor()
        continueBtn.titleLabel?.font = Fonts.mediumFontsSize16
        continueBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func configurePhoneNumberKit(){
        phoneNumberTextField.delegate = self
        phoneNumberTextField.withFlag = true
        phoneNumberTextField.withPrefix = true
        phoneNumberTextField.updateFlag()
        phoneNumberTextField.updatePlaceholder()
        phoneNumberTextField.flagButton.isUserInteractionEnabled = true
        phoneNumberTextField.withDefaultPickerUI = true
        phoneNumberTextField.withExamplePlaceholder = true
        phoneNumberTextField.addTarget(self, action: #selector(phoneTextChanged), for: .editingChanged)
    }
    
    private func checkPhoneNmbIsValidOrNot() -> Bool{
        if self.phoneNumberTextField.isValidNumber{
            return true
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.enterValidNumber()])
            return false
        }
    }
    
    //MARK: - ACTIONS -
    
    @objc func phoneTextChanged(_ textField: UITextField) {
        if textField == phoneNumberTextField {
            if phoneNumberTextField.isValidNumber{
//                continueBtn.isEnabled = true
                phoneNumberTextField.textColor = .white
            }else{
//                continueBtn.isEnabled = false
                phoneNumberTextField.textColor = .red
            }
        }
    }
    
    
    @IBAction func didTapBackBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapContinueBtn(_ sender: UIButton) {
        sender.showAnimation {
            if Network.isAvailable && !self.continueBtn.isAnimating{
                if self.checkPhoneNmbIsValidOrNot(){
                    self.continueBtn.showLoading()
                    let request = ForgotPasswordRequest(phone: self.getPhoneNmb)
                    self.viewModel.forgotPassword(request: request)
                }
            }else{
                self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain()])
            }
        }
    }
    
}

//MARK: - EXTENSION FOR FORGOT PASSWORD VIEW MODEL DELGATES -

extension ForgotPasswordVC: ForgotPasswordViewModelDelegate{
    
    func didReceive(response: BaseResponse) {
        continueBtn.hideLoading()
        guard let verificationVC = R.storyboard.authSB.phoneVerificationVC() else {return}
        verificationVC.mode = .fromForgotPassword
        verificationVC.phoneNumber = self.getPhoneNmb
        self.navigationController?.pushViewController(verificationVC, animated: true)
    }
    
    func didReceiveResponseWith(errorMessage: [String]?,statusCode: Int?) {
        continueBtn.hideLoading()
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}

//MARK: - TEXTFIELD DELEGATES -

extension ForgotPasswordVC: UITextFieldDelegate{
    
    
}
