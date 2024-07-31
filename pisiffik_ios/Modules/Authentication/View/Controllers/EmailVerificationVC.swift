//
//  EmailVerificationVC.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 09/05/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import UIKit
import OTPFieldView

class EmailVerificationVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var enterCodeLbl: UILabel!
    @IBOutlet weak var sentCodeLbl: UILabel!
    @IBOutlet weak var otpView: OTPFieldView!
    @IBOutlet weak var editBtn: LoadingButton!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var verifyBtn: LoadingButton!
    @IBOutlet weak var didNotGetCodeLbl: UILabel!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    
    //MARK: - PROPERTIES -
    
    private var verifyVM : SignupViewModel = SignupViewModel()
    private var updateEmailVM : UpdateEmailViewModel = UpdateEmailViewModel()
    
    var email : String = ""
    var phoneNumber : String = ""
    var timer: Timer?
    var counter = 80
    var otpCode: String = ""
    var user: UserData? = DBUserManagerRepository().getUser()
    
    var mode: SignMode = {
        let mode : SignMode = .fromSignup
        return mode
    }()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        setupOtpView()
        verifyVM.delegate = self
        updateEmailVM.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        enterCodeLbl.text = PisiffikStrings.verifyEmail()
        sentCodeLbl.text = PisiffikStrings.weHaveSentToYourEmail()
        emailLbl.text = email
        verifyBtn.setTitle(PisiffikStrings.verify(), for: .normal)
        didNotGetCodeLbl.text = PisiffikStrings.didNotGetACode()
    }
    
    func setUI() {
        enterCodeLbl.font = Fonts.semiBoldFontsSize24
        enterCodeLbl.textColor = R.color.textWhiteColor()
        sentCodeLbl.font = Fonts.mediumFontsSize14
        sentCodeLbl.textColor = R.color.textWhiteColor()
        emailLbl.font = Fonts.mediumFontsSize14
        emailLbl.textColor = R.color.lightGreenColor()
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
        if self.mode == .fromLogin{
            self.sendOTPTo(email: self.email)
        }
    }
    
    private func getUserData(user: UserData,accessToken: String) -> UserData{
        return UserData(id: user.id, fullName: user.fullName, phone: user.phone, email: user.email, fcmToken: user.fcmToken, emailVerifiedAt: user.emailVerifiedAt, dob: user.dob, country: Description(id: user.country?.id, name: user.country?.name), gender: Description(id: user.gender?.id, name: user.gender?.name), state: Description(id: user.state?.id, name: user.state?.name), city: Description(id: user.city?.id, name: user.city?.name), address: user.address, deviceType: user.deviceType, latitude: user.latitude, longitude: user.longitude, otp: user.otp, isVerified: user.isVerified, rememberToken: user.rememberToken, deletedAt: user.deletedAt, createdAt: user.createdAt, updatedAt: user.updatedAt, token: accessToken,phoneVerify: user.phoneVerify,emailVerify: 1)
    }
    
    private func sendOTPTo(email: String){
        self.verifyVM.resendCodeOnEmail(request: ResendOTPEmailRequest(email: email))
    }
    
    private func didUpdate(email: String){
        self.editBtn.showLoading()
        let request = UpdateEmailRequest(oldEmail: self.email, newEmail: email)
        self.updateEmailVM.updateEmail(request: request)
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton){
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapEditBtn(_ sender: UIButton) {
        sender.showAnimation {
            if self.editBtn.isAnimating {return}
            guard let updateVC = R.storyboard.authSB.updatePhoneEmailVC() else {return}
            updateVC.mode = .email
            updateVC.delegates = self
            self.present(updateVC, animated: true)
        }
    }
    
    @IBAction func didTapVerifyBtn(_ sender: UIButton) {
        sender.showAnimation { [weak self] in
            guard let self = self else {return}
            if self.verifyBtn.isAnimating {return}
            self.verifyBtn.showLoading()
            let request = VerifyEmailRequest(otp: self.otpCode, email: self.email)
            self.verifyVM.verifyEmail(request: request)
        }
    }
    
    @IBAction func didTapResendBtn(_ sender: UIButton) {
        sender.showAnimation { [weak self] in
            guard let self = self else {return}
            if self.verifyBtn.isAnimating {return}
            if Network.isAvailable{
                self.resendBtn.isEnabled = false
                self.verifyVM.resendCodeOnEmail(request: ResendOTPEmailRequest(email: self.email))
            }else{
                self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain()])
            }
        }
    }
    
    
}

//MARK: - EXTENSION FOR EMAIL VERIFY VIEW MODEL DELEGATES -

extension EmailVerificationVC: SignupViewModelDelegate{
    
    func didReceiveVerify(response: VerifyResponse) {
        self.resendBtn.isEnabled = true
        self.verifyBtn.hideLoading()
        if let user = self.user, let accessToken = response.data?.accessToken{
            let user = self.getUserData(user: user, accessToken: accessToken)
            DBUserManagerRepository().create(record: user)
        }
        if (self.mode == .fromSignup) || (self.mode == .fromLogin){
            guard let verificationDoneVC = R.storyboard.authSB.verificationDoneVC() else {return}
            self.navigationController?.pushViewController(verificationDoneVC, animated: false)
        }else{
            RootRouter().loadMainTabbarScreens()
        }
    }
    
    func didReceiveVerify(errorMessage: [String]?, statusCode: Int?) {
        self.resendBtn.isEnabled = true
        self.verifyBtn.hideLoading()
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}

//MARK: - RESEND OTP FROM SIGNUP DELEGATES -

extension EmailVerificationVC{
    
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

//MARK: - EXTENSION FOR UpdateEmailViewModel DELEGATES -

extension EmailVerificationVC: UpdateEmailViewModelDelegate{
    
    func didReceive(response: UpdateEmailResponse) {
        editBtn.hideLoading()
        self.email = response.data?.newEmail ?? ""
        self.emailLbl.text = response.data?.newEmail
        AlertController.showAlert(title: PisiffikStrings.success(), message: response.responseMessage, inVC: self)
    }
    
    func didReceive(errorMessage: [String]?, statusCode: Int?) {
        editBtn.hideLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
        }
    }
    
}

//MARK: - EXTENSION FOR UPDATE PHONE EMAIL VC DELEGATES -

extension EmailVerificationVC: UpdatePhoneEmailVCDelegates{
    
    func didUpdatePhoneEmail(type: UpdatePhoneEmailVCType, text: String, isValidNmb: Bool) {
        if type == .email{
            self.didUpdate(email: text)
        }
    }
    
}

//MARK: - EXTENSION FOR OTPFieldViewDelegate -

extension EmailVerificationVC: OTPFieldViewDelegate {
    
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
