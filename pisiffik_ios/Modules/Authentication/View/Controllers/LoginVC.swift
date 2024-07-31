//
//  LoginVC.swift
//  pisiffik-ios
//
//  Created by Haider Ali on 23/05/2022.
//  Copyright © 2022 softwarealliance.dk. All rights reserved.
//

import UIKit
import PhoneNumberKit
import CoreLocation

class LoginVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var loginAccountLbl: UILabel!
    @IBOutlet weak var phoneNmbLbl: UILabel!
    @IBOutlet weak var phoneNumberTextField: PhoneNumberTextField!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var hidePasswordBtn: UIButton!{
        didSet{
            hidePasswordBtn.setImage(R.image.ic_hide_password(), for: .normal)
            hidePasswordBtn.setImage(R.image.ic_show_password(), for: .selected)
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var loginBtn: LoadingButton!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var bySigninLbl: UILabel!
    @IBOutlet weak var termsOfUseBtn: UIButton!
    @IBOutlet weak var andLbl: UILabel!
    @IBOutlet weak var privacyBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    private let locationManager = CLLocationManager()
    var isValidNumber : Bool = false
    var viewModel : LoginViewModel = LoginViewModel()
    
    private var getPhoneNmb : String{
        return "+\(phoneNumberTextField.phoneNumber?.countryCode ?? 0)\(phoneNumberTextField.phoneNumber?.nationalNumber ?? 0)"
    }
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        configurePhoneNumberKit()
        viewModel.delegate = self
        self.getUserLoaction()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if phoneNumberTextField.isValidNumber{
//            loginBtn.isEnabled = true
//        }else{
//            loginBtn.isEnabled = false
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationBarShould(hidden: true)
    }
    
    //MARK: - METHODS -
    
    @objc func setText(){
        self.loginAccountLbl.text = PisiffikStrings.loginYourAccount()
        phoneNmbLbl.text = PisiffikStrings.mobileNumber()
        orLbl.text = PisiffikStrings.or()
        emailLbl.text = PisiffikStrings.email()
        passwordLbl.text = PisiffikStrings.password()
        loginBtn.setTitle(PisiffikStrings.login(), for: .normal)
        createAccountBtn.setTitle(PisiffikStrings.notRegisterYetCreateAnAccount(), for: .normal)
        bySigninLbl.text = PisiffikStrings.bySignInYouAgreeToPisiffik()
        andLbl.text = PisiffikStrings._and()
    }
    
    func setUI() {
        loginAccountLbl.font = Fonts.semiBoldFontsSize24
        loginAccountLbl.textColor = R.color.textWhiteColor()
        phoneNmbLbl.font = Fonts.mediumFontsSize14
        phoneNmbLbl.textColor = R.color.textWhiteColor()
        orLbl.font = Fonts.mediumFontsSize14
        orLbl.textColor = R.color.textWhiteColor()
        emailLbl.font = Fonts.mediumFontsSize14
        emailLbl.textColor = R.color.textWhiteColor()
        passwordLbl.font = Fonts.mediumFontsSize14
        passwordLbl.textColor = R.color.textWhiteColor()
        forgotPasswordBtn.titleLabel?.font = Fonts.mediumFontsSize14
        loginBtn.titleLabel?.font = Fonts.mediumFontsSize16
        loginBtn.backgroundColor = R.color.lightGreenColor()
        loginBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
        createAccountBtn.titleLabel?.font = Fonts.mediumFontsSize14
        createAccountBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
        bySigninLbl.font = Fonts.regularFontsSize12
        bySigninLbl.textColor = R.color.textLightGrayColor()
        termsOfUseBtn.titleLabel?.font = Fonts.regularFontsSize12
        andLbl.font = Fonts.regularFontsSize12
        andLbl.textColor = R.color.textLightGrayColor()
        privacyBtn.titleLabel?.font = Fonts.regularFontsSize12
        forgotPasswordBtn.titleLabel?.text = PisiffikStrings.forgotPassword()
        termsOfUseBtn.titleLabel?.text = PisiffikStrings.termsOfUse()
        privacyBtn.titleLabel?.text = PisiffikStrings.privacyPolicy()
        forgotPasswordBtn.underline()
        termsOfUseBtn.underline()
        privacyBtn.underline()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    private func configurePhoneNumberKit(){
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
    
    func getUserLoaction(){
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK: - ACTIONS -
    
    
    @objc func phoneTextChanged(_ textField: UITextField) {
        if textField == phoneNumberTextField {
            if phoneNumberTextField.isValidNumber{
//                loginBtn.isEnabled = true
                phoneNumberTextField.textColor = .white
            }else{
//                loginBtn.isEnabled = false
                phoneNumberTextField.textColor = .red
            }
        }
    }
    
    
    @IBAction func didTapShowPasswordBtn(_ sender: UIButton) {
        self.hidePasswordBtn.isSelected = !self.hidePasswordBtn.isSelected
        if self.hidePasswordBtn.isSelected == true {
            self.passwordTextField.isSecureTextEntry = false
        }else{
            self.passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func didTapForgotPasswordBtn(_ sender: UIButton) {
        sender.showAnimation {
            guard let forgotPasswordVC = R.storyboard.authSB.forgotPasswordVC() else {return}
            self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
        }
    }
    
    @IBAction func didTapLoginBtn(_ sender: UIButton) {
        if Network.isAvailable && !self.loginBtn.isAnimating{
//            if self.checkPhoneNmbIsValidOrNot(){
            let request = LoginValidationRequest(phone: getPhoneNmb, email: self.emailTextField.text?.replacingOccurrencesOfWhiteSpaces() ?? "", password: self.passwordTextField.text ?? "", fcm_token: Constants.fcmToken)
            
            sender.showAnimation {
                self.loginBtn.showLoading()
                var countryCode: String = ""
                if let _countryCode = self.phoneNumberTextField.phoneNumber?.countryCode{
                    countryCode = "+\(_countryCode)"
                }else{
                    countryCode = "+00"
                }
                self.viewModel.loginUser(loginRequest: request,countryCode: countryCode,isValidPhone: self.phoneNumberTextField.isValidNumber)
            }
//            }
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain()])
        }
    }
    
    @IBAction func didTapCreateAccountBtn(_ sender: UIButton) {
        sender.showAnimation {
            guard let signUpVC = R.storyboard.authSB.signUpVC() else {return}
            self.navigationController?.pushViewController(signUpVC, animated: true)
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

//MARK: - EXTENSION FOR LOGIN VIEW MODEL -

extension LoginVC: LoginViewModelDelegate{
    
    func didReceive(response: AuthResponse) {
        self.loginBtn.hideLoading()
        if let mediaURL = response.data?.media_url{
            UserDefault.shared.saveMedia(url: mediaURL)
        }
        if let userObj = response.data?.user,
            let phoneVerify = response.data?.user?.phoneVerify,
            let emailVerify = response.data?.user?.emailVerify{
            let accessToken = response.data?.access_token ?? ""
            DBUserManagerRepository().create(record: getUserData(user: userObj, accessToken: accessToken))
            if ((phoneVerify == 1) && (emailVerify == 1)){
                RootRouter().loadMainTabbarScreens()
            }else if phoneVerify == 0{
                self.showAlert(title: PisiffikStrings.alert(), description: response.responseMessage ?? "",alertType: .phoneVerifyError,delegate: self)
            }else if emailVerify == 0{
                self.showAlert(title: PisiffikStrings.alert(), description: response.responseMessage ?? "",alertType: .emailVerifyError,delegate: self)
            }else{
                AlertController.showAlert(title: PisiffikStrings.alert(), message: response.responseMessage ?? "", inVC: self)
            }
        }
    }
    
    func didReceive(errorMessage: [String]?,statusCode: Int?) {
        self.loginBtn.hideLoading()
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}

//MARK: - EXTENSION FOR StoreHelpVCDelegates -

extension LoginVC: StoreHelpVCDelegates{
    
    func didTapAlertDoneBtn(alertType: AlertType) {
        guard let user = DBUserManagerRepository().getUser() else {return}
        self.dismiss(animated: true)
        if alertType == .phoneVerifyError{
            guard let verificationVC = R.storyboard.authSB.phoneVerificationVC() else {return}
            verificationVC.phoneNumber = user.phone ?? ""
            verificationVC.email = user.email ?? ""
            verificationVC.mode = .fromLogin
            self.navigationController?.pushViewController(verificationVC, animated: true)
        }else if alertType == .emailVerifyError{
            guard let verificationVC = R.storyboard.authSB.emailVerificationVC() else {return}
            verificationVC.phoneNumber = user.phone ?? ""
            verificationVC.email = user.email ?? ""
            verificationVC.mode = .fromLogin
            self.navigationController?.pushViewController(verificationVC, animated: true)
        }
    }
    
}

//MARK: - EXTENSION FOR CLLOCATION MANAGER DELEGATES -

    
extension LoginVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}


//MARK: - EXTENSION FOR GET USER DATA -

extension LoginVC{
    
    private func getUserData(user: UserData,accessToken: String) -> UserData{
        return UserData(id: user.id, fullName: user.fullName, phone: user.phone, email: user.email, fcmToken: user.fcmToken, emailVerifiedAt: user.emailVerifiedAt, dob: user.dob, country: Description(id: user.country?.id, name: user.country?.name), gender: Description(id: user.gender?.id, name: user.gender?.name), state: Description(id: user.state?.id, name: user.state?.name), city: Description(id: user.city?.id, name: user.city?.name), address: user.address, deviceType: user.deviceType, latitude: user.latitude, longitude: user.longitude, otp: user.otp, isVerified: user.isVerified, rememberToken: user.rememberToken, deletedAt: user.deletedAt, createdAt: user.createdAt, updatedAt: user.updatedAt, token: accessToken,phoneVerify: user.phoneVerify,emailVerify: user.emailVerify)
    }
    
}
