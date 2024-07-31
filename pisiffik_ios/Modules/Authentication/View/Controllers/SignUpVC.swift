//
//  SignUpVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 30/05/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import PhoneNumberKit
import ActiveLabel

class SignUpVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn : UIButton!
    @IBOutlet weak var titleLbl : UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var phoneNumberTextField: PhoneNumberTextField!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var hidePasswordBtn: UIButton!{
        didSet{
            hidePasswordBtn.setImage(R.image.ic_hide_password(), for: .normal)
            hidePasswordBtn.setImage(R.image.ic_show_password(), for: .selected)
        }
    }
    @IBOutlet weak var continueBtn: LoadingButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var bySignupLbl: UILabel!
    @IBOutlet weak var termsOfUseBtn: UIButton!
    @IBOutlet weak var andLbl: UILabel!
    @IBOutlet weak var privacyBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    var viewModel : SignupViewModel = SignupViewModel()
    var isValidNumber : Bool = false
    
    private var getPhoneNmb : String{
        return "+\(phoneNumberTextField.phoneNumber?.countryCode ?? 123)\(phoneNumberTextField.phoneNumber?.nationalNumber ?? 456)"
    }
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        nameTextField.delegate = self
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
        titleLbl.text = PisiffikStrings.joinPisiffik()
        nameLbl.text = PisiffikStrings.fullName()
        mobileNumberLbl.text = PisiffikStrings.mobileNumber()
        emailLbl.text = PisiffikStrings.email()
        passwordLbl.text = PisiffikStrings.password()
        continueBtn.setTitle(PisiffikStrings._continue(), for: .normal)
        loginBtn.setTitle(PisiffikStrings.alreadyAMemberLogin(), for: .normal)
        bySignupLbl.text = PisiffikStrings.bySignUpYouAgreeToPisiffik()
        andLbl.text = PisiffikStrings._and()
    }
    
    func setUI() {
        titleLbl.font = Fonts.semiBoldFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
        nameLbl.font = Fonts.mediumFontsSize14
        nameLbl.textColor = R.color.textWhiteColor()
        mobileNumberLbl.font = Fonts.mediumFontsSize14
        mobileNumberLbl.textColor = R.color.textWhiteColor()
        emailLbl.font = Fonts.mediumFontsSize14
        emailLbl.textColor = R.color.textWhiteColor()
        passwordLbl.font = Fonts.mediumFontsSize14
        passwordLbl.textColor = R.color.textWhiteColor()
        continueBtn.titleLabel?.font = Fonts.mediumFontsSize16
        continueBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
        bySignupLbl.font = Fonts.regularFontsSize12
        bySignupLbl.textColor = R.color.textLightGrayColor()
        termsOfUseBtn.titleLabel?.font = Fonts.regularFontsSize12
        andLbl.font = Fonts.regularFontsSize12
        andLbl.textColor = R.color.textLightGrayColor()
        privacyBtn.titleLabel?.font = Fonts.regularFontsSize12
        loginBtn.titleLabel?.font = Fonts.mediumFontsSize14
        loginBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
        termsOfUseBtn.titleLabel?.text = PisiffikStrings.termsOfUse()
        privacyBtn.titleLabel?.text = PisiffikStrings.privacyPolicy()
        termsOfUseBtn.underline()
        privacyBtn.underline()
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
            return false
        }
    }
    
    private func navigateToTermsOfUseVC() {
        guard let termsOfUse = R.storyboard.privacySB.privacyVC() else {
            return
        }
        termsOfUse.mode = .termsOfUse
        self.push(controller: termsOfUse, hideBar: true, animated: true)
    }
    
    private func navigateToPrivacyPolicyVC() {
        guard let privacyVC = R.storyboard.privacySB.privacyVC() else {
            return
        }
        privacyVC.mode = .privacy
        self.push(controller: privacyVC, hideBar: true, animated: true)
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
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func didTapHidePasswordBtn(_ sender: UIButton) {
        self.hidePasswordBtn.isSelected = !self.hidePasswordBtn.isSelected
        if self.hidePasswordBtn.isSelected == true {
            self.passwordTextField.isSecureTextEntry = false
        }else{
            self.passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func didTapContinueBtn(_ sender: UIButton) {
        let request = SignupRequest(fullName: self.nameTextField.text ?? "", phone: getPhoneNmb, email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", deviceType: .iOS, fcmToken: Constants.fcmToken)
        sender.showAnimation {
            if !self.continueBtn.isAnimating{
                self.continueBtn.showLoading()
                self.viewModel.registerUser(signupRequest: request,isValidPhone: self.checkPhoneNmbIsValidOrNot())
            }
        }
    }
    
    @IBAction func didTapLoginBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapTermsOfUseBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.navigateToTermsOfUseVC()
        }
    }
    
    @IBAction func didTapPrivacyPolicyBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.navigateToPrivacyPolicyVC()
        }
    }
    
}


//MARK: - EXTENSION FOR SIGNUP VIEW MODEL DELEGATES -

extension SignUpVC: SignupViewModelDelegate{
    
    func didReceiveSignup(response: AuthResponse) {
        self.continueBtn.hideLoading()
        let phoneNmb = getPhoneNmb.replacingOccurrencesOfWhiteSpaces()
        let email = emailTextField.text?.replacingOccurrencesOfWhiteSpaces() ?? ""
        guard let verificationVC = R.storyboard.authSB.phoneVerificationVC() else {return}
        verificationVC.phoneNumber = phoneNmb
        verificationVC.email = email
        verificationVC.mode = .fromSignup
        if let user = response.data?.user{
            verificationVC.user = self.getUserDataFrom(response: user)
        }
        if let mediaURL = response.data?.media_url{
            UserDefault.shared.saveMedia(url: mediaURL)
        }
        self.navigationController?.pushViewController(verificationVC, animated: true)
    }
    
    func didReceiveSignup(errorMessage: [String]?,statusCode: Int?) {
        self.continueBtn.hideLoading()
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}

//MARK: - EXTENSION FOR PRIVATE METHODS -

extension SignUpVC{
    
    private func getUserDataFrom(response: UserData) -> UserData{
        
        return UserData(id: response.id, fullName: response.fullName, phone: response.phone, email: response.email, fcmToken: response.fcmToken, emailVerifiedAt: response.emailVerifiedAt, dob: response.dob, country: Description(id: response.country?.id, name: response.country?.name), gender: Description(id: response.gender?.id, name: response.gender?.name), state: Description(id: response.state?.id, name: response.state?.name), city: Description(id: response.city?.id, name: response.city?.name), address: response.address, deviceType: response.deviceType, latitude: response.latitude, longitude: response.longitude, otp: response.otp, isVerified: response.isVerified, rememberToken: response.rememberToken, deletedAt: response.deletedAt, createdAt: response.createdAt, updatedAt: response.updatedAt, token: response.token)
    }
    
}


//MARK: - TEXTFIELD DELEGATES -

extension SignUpVC: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == nameTextField{
            if let text = nameTextField.text{
                if let firstText = text.first{
                    if firstText == " "{
                        nameTextField.text?.removeFirst()
                    }
                }
                if let lastText = text.last{
                    if text.count > 1{
                        if lastText == " "{
                            nameTextField.text?.removeLast()
                        }
                    }
                }
            }
        }
    }
    
    
}
