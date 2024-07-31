//
//  PhoneVerificationVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 30/05/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import OTPFieldView

class PhoneVerificationVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var pageNmbLbl: UILabel!
    @IBOutlet weak var enterCodeLbl: UILabel!
    @IBOutlet weak var sentCodeLbl: UILabel!
    @IBOutlet weak var otpView: OTPFieldView!
    @IBOutlet weak var editBtn: LoadingButton!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var verifyBtn: LoadingButton!
    @IBOutlet weak var didNotGetCodeLbl: UILabel!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    
    //MARK: - PROPERTIES -
    
    var mode : SignMode = {
        let mode : SignMode = .fromSignup
        return mode
    }()
    
    var viewModel : ForgotPasswordViewModel = ForgotPasswordViewModel()
    var verifyPhoneVM : SignupViewModel = SignupViewModel()
    var updatePhoneVM : UpdatePhoneViewModel = UpdatePhoneViewModel()
    
    var phoneNumber = ""
    var email : String = ""
    var timer: Timer?
    var counter = 80
    var otpCode: String = ""
    var user: UserData? = DBUserManagerRepository().getUser()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        setupOtpView()
        self.viewModel.delegate = self
        self.verifyPhoneVM.delegate = self
        self.updatePhoneVM.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        if self.mode == .fromMyProfile{
            enterCodeLbl.text = PisiffikStrings.enterVerificationCode()
            sentCodeLbl.text = PisiffikStrings.weHaveSentToYourEmail()
            phoneNumberLbl.text = email
        }else{
            enterCodeLbl.text = PisiffikStrings.verifyPhone()
            sentCodeLbl.text = PisiffikStrings.weHaveSentToYourMobileNumber()
            phoneNumberLbl.text = phoneNumber
        }
        verifyBtn.setTitle(PisiffikStrings.verify(), for: .normal)
        didNotGetCodeLbl.text = PisiffikStrings.didNotGetACode()
    }
    
    func setUI() {
        enterCodeLbl.font = Fonts.semiBoldFontsSize24
        enterCodeLbl.textColor = R.color.textWhiteColor()
        sentCodeLbl.font = Fonts.mediumFontsSize14
        sentCodeLbl.textColor = R.color.textWhiteColor()
        phoneNumberLbl.font = Fonts.mediumFontsSize14
        phoneNumberLbl.textColor = R.color.lightGreenColor()
        verifyBtn.titleLabel?.font = Fonts.mediumFontsSize16
        verifyBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
        verifyBtn.backgroundColor = R.color.lightGreenColor()
        didNotGetCodeLbl.font = Fonts.mediumFontsSize14
        didNotGetCodeLbl.textColor = R.color.darkGrayColor()
        resendBtn.titleLabel?.font = Fonts.mediumFontsSize14
        resendBtn.setTitleColor(R.color.textWhiteColor(), for: .normal)
        resendBtn.titleLabel?.text = PisiffikStrings.resend()
        resendBtn.underline()
        timeLbl.font = Fonts.mediumFontsSize14
        timeLbl.textColor = R.color.lightGreenColor()
        setupTimer()
        if self.mode == .fromLogin{
            self.sendOTPToPhone(number: self.phoneNumber)
        }
        self.pageNmbLbl.isHidden = self.mode == .fromForgotPassword ? true : false
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        if counter > 0 {
            resendBtn.isEnabled = false
//            resendBtn.setTitleColor(R.color.darkGrayColor(), for: .normal)
            timeLbl.isHidden = false
            let minComponents = counter / 60
            let secComponents = counter % 60
            let min = minComponents < 10 ? "0\(minComponents)" : "\(minComponents)"
            let sec = secComponents < 10 ? "0\(secComponents)" : "\(secComponents)"
            timeLbl.text = "\(min):\(sec)s"
            counter -= 1
        } else {
            timer?.invalidate()
            timer = nil
            timeLbl.isHidden = true
            resendBtn.isEnabled = true
            resendBtn.setTitleColor(.white, for: .normal)
        }
    }
    
    func setupOtpView(){
        self.otpView.fieldsCount = 6
        self.otpView.fieldBorderWidth = 2
        self.otpView.defaultBorderColor = UIColor.white
        self.otpView.filledBorderColor = UIColor.green
        self.otpView.cursorColor = UIColor.lightGray
        self.otpView.fieldTextColor = UIColor.white
        self.otpView.displayType = .underlinedBottom
        self.otpView.fieldSize = 40
        self.otpView.separatorSpace = 8
        self.otpView.shouldAllowIntermediateEditing = false
        self.otpView.delegate = self
        self.otpView.initializeUI()
    }
    
    func sendOTPToPhone(number: String){
        self.verifyPhoneVM.resendCodeOnPhone(request: ForgotPasswordRequest(phone: number))
    }
    
    private func didUpdate(phone: String,isValidPhone: Bool){
        self.editBtn.showLoading()
        let request = UpdatePhoneRequest(oldPhone: self.phoneNumber, newPhone: phone)
        self.updatePhoneVM.updatePhone(request: request,isValidPhone: isValidPhone)
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapEditBtn(_ sender: UIButton) {
        sender.showAnimation {
            if self.mode == .fromForgotPassword{
                self.navigationController?.popViewController(animated: true)
            }else{
                if self.editBtn.isAnimating {return}
                guard let updateVC = R.storyboard.authSB.updatePhoneEmailVC() else {return}
                updateVC.mode = .phone
                updateVC.delegates = self
                self.present(updateVC, animated: true)
            }
        }
    }
    
    @IBAction func didTapVerifyBtn(_ sender: UIButton) {
        sender.showAnimation {
            if self.verifyBtn.isAnimating {return}
            if self.otpCode.isEmpty{
                self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.pleaseEnterValidOtpCodeForVerification()])
                return
            }else{
                self.verifyBtn.showLoading()
                let request = VerifyPhoneRequest(otp: self.otpCode, phone: self.phoneNumber)
                self.verifyPhoneVM.verifyPhone(request: request)
            }
        }
    }
    
    @IBAction func didTapResendBtn(_ sender: UIButton) {
        sender.showAnimation { [weak self] in
            guard let self = self else {return}
            if self.verifyBtn.isAnimating {return}
            if Network.isAvailable{
                self.resendBtn.isEnabled = false
                if self.mode == .fromForgotPassword{
                    self.viewModel.forgotPassword(request: ForgotPasswordRequest(phone: self.phoneNumber))
                }else{
                    self.verifyPhoneVM.resendCodeOnPhone(request: ForgotPasswordRequest(phone: self.phoneNumber))
                }
            }else{
                self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain()])
            }
        }
    }
    
    
}

//MARK: - EXTENSION FOR SIGNUP VIEW MODEL DELEGATE -

extension PhoneVerificationVC: SignupViewModelDelegate{
    
    func didReceiveVerify(response: VerifyResponse) {
        self.resendBtn.isEnabled = true
        self.verifyBtn.hideLoading()
        self.otpCode = ""
        if self.mode == .fromForgotPassword{
            if let accessToken = response.data?.accessToken{
                UserDefault.shared.saveAccessTokenForResetPassword(token: accessToken)
            }
            guard let resetPasswordVC = R.storyboard.authSB.resetPasswordVC() else {return}
            self.navigationController?.pushViewController(resetPasswordVC, animated: false)
            
        }else{
            guard let emailVerificationVC = R.storyboard.authSB.emailVerificationVC() else {return}
            emailVerificationVC.phoneNumber = self.phoneNumber
            emailVerificationVC.email = email
            emailVerificationVC.mode = .fromSignup
            if let user = self.user{
                var currentUser = user
                currentUser.phoneVerify = 1
                emailVerificationVC.user = currentUser
            }
            self.navigationController?.pushViewController(emailVerificationVC, animated: false)
        }
        
    }
    
    func didReceiveVerify(errorMessage: [String]?,statusCode: Int?) {
        self.resendBtn.isEnabled = true
        self.verifyBtn.hideLoading()
        self.otpCode = ""
        self.otpView.initializeUI()
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage ?? [])
    }
    
}

//MARK: - RESEND OTP FROM SIGNUP DELEGATES -

extension PhoneVerificationVC{
    
    func didReceiveResendOTP(response: BaseResponse) {
        self.resendBtn.isEnabled = true
        DispatchQueue.main.async {
            self.counter = 80
            self.setupTimer()
        }
    }
    
    func didReceiveResendOTP(errorMessage: [String]?, statusCode: Int?) {
        self.resendBtn.isEnabled = true
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}

//MARK: - RESEND OTP VIEW MODEL DELEGATES -

extension PhoneVerificationVC: ForgotPasswordViewModelDelegate{
    
    func didReceive(response: BaseResponse) {
        self.resendBtn.isEnabled = true
        DispatchQueue.main.async {
            self.counter = 80
            self.setupTimer()
        }
    }
    
    func didReceiveResponseWith(errorMessage: [String]?,statusCode: Int?) {
        self.resendBtn.isEnabled = true
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}

//MARK: - EEXTENSION FOR UpdatePhoneViewModel DELEGATES -

extension PhoneVerificationVC: UpdatePhoneViewModelDelegate{
    
    func didReceive(response: UpdatePhoneResponse) {
        self.editBtn.hideLoading()
        self.phoneNumber = response.data?.newPhone ?? ""
        self.phoneNumberLbl.text = response.data?.newPhone
        AlertController.showAlert(title: PisiffikStrings.alert(), message: response.responseMessage, inVC: self)
    }
    
    func didReceive(errorMessage: [String]?, statusCode: Int?) {
        self.editBtn.hideLoading()
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}

//MARK: - EXTENSION FOR UPDATE PHONE VC DELEGATES -

extension PhoneVerificationVC: UpdatePhoneEmailVCDelegates{
    
    func didUpdatePhoneEmail(type: UpdatePhoneEmailVCType, text: String, isValidNmb: Bool) {
        if type == .phone{
            if isValidNmb{
                self.didUpdate(phone: text, isValidPhone: isValidNmb)
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    self?.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.enterValidNumber()])
                }
            }
        }
    }
    
}

//MARK: - EXTENSION FOR OTPFieldViewDelegate -

extension PhoneVerificationVC: OTPFieldViewDelegate {
    
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        if !hasEntered{
            self.otpCode = ""
        }
        print("Has entered all OTP? \(hasEntered)")
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        otpCode = otpString
        Constants.printLogs("otpString: \(otpString)")
    }
    
}
