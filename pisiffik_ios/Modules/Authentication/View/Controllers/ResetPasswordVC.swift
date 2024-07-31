//
//  ResetPasswordVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 01/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var passwordDetailLbl: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordBtn: UIButton!{
        didSet{
            showPasswordBtn.setImage(R.image.ic_hide_password(), for: .normal)
            showPasswordBtn.setImage(R.image.ic_show_password(), for: .selected)
        }
    }
    @IBOutlet weak var confirmPasswordLbl: UILabel!
    @IBOutlet weak var confirmPasswordDetailLbl: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var showConfirmPasswordBtn: UIButton!{
        didSet{
            showConfirmPasswordBtn.setImage(R.image.ic_hide_password(), for: .normal)
            showConfirmPasswordBtn.setImage(R.image.ic_show_password(), for: .selected)
        }
    }
    @IBOutlet weak var continueBtn: LoadingButton!
    
    //MARK: - PROPERTIES -
    
    private var viewModel : ResetPasswordViewModel = ResetPasswordViewModel()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        self.viewModel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.resetYourPassword()
        passwordLbl.text = PisiffikStrings.newPassword()
        passwordDetailLbl.text = PisiffikStrings.mustBeAtLeastSixCharacters()
        confirmPasswordLbl.text = PisiffikStrings.confirmPassword()
        confirmPasswordDetailLbl.text = PisiffikStrings.mustBeAtLeastSixCharacters()
        continueBtn.setTitle(PisiffikStrings.resetPassword(), for: .normal)
    }
    
    func setUI() {
        titleLbl.font = Fonts.semiBoldFontsSize24
        titleLbl.textColor = R.color.textWhiteColor()
        passwordLbl.font = Fonts.mediumFontsSize14
        passwordLbl.textColor = R.color.textWhiteColor()
        passwordDetailLbl.font = Fonts.regularItalicFontsSize12
        passwordDetailLbl.textColor = R.color.darkGrayColor()
        confirmPasswordLbl.font = Fonts.mediumFontsSize14
        confirmPasswordLbl.textColor = R.color.textWhiteColor()
        confirmPasswordDetailLbl.font = Fonts.regularItalicFontsSize12
        confirmPasswordDetailLbl.textColor = R.color.darkGrayColor()
        continueBtn.titleLabel?.font = Fonts.mediumFontsSize16
        continueBtn.setTitleColor(R.color.textBlackColor(), for: .normal)
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.navigationController?.popToViewController(of: LoginVC.self, animated: true)
        }
    }
    
    @IBAction func didTapShowPasswordBtn(_ sender: UIButton) {
        self.showPasswordBtn.isSelected = !self.showPasswordBtn.isSelected
        if self.showPasswordBtn.isSelected == true {
            self.passwordTextField.isSecureTextEntry = false
        }else{
            self.passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func didTapShowConfirmPasswordBtn(_ sender: UIButton) {
        self.showConfirmPasswordBtn.isSelected = !self.showConfirmPasswordBtn.isSelected
        if self.showConfirmPasswordBtn.isSelected == true {
            self.confirmPasswordTextField.isSecureTextEntry = false
        }else{
            self.confirmPasswordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func didTapContinueBtn(_ sender: UIButton) {
        sender.showAnimation {
            if self.validPassword() && !self.continueBtn.isAnimating{
                self.continueBtn.showLoading()
                let request = ResetPasswordRequest(password: self.passwordTextField.text ?? "")
                self.viewModel.resetPassword(request: request)
            }
        }
    }
    
}


//MARK: - EXTENSION FOR RESET PASSWORD VIEW MODEL DELEGATES -

extension ResetPasswordVC: ResetPasswordViewModelDelegate{
    
    func didReceive(response: BaseResponse) {
        continueBtn.hideLoading()
        UserDefault.shared.saveAccessTokenForResetPassword(token: "")
        self.navigationController?.popToViewController(of: LoginVC.self, animated: false)
    }
    
    func didReceiveResponseWith(errorMessage: [String]?,statusCode: Int?) {
        continueBtn.hideLoading()
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}

//MARK: - EXTENSION FOR VALIDATIONS -

extension ResetPasswordVC{
    
    private func validPassword() -> Bool{
        let validate = ResetPasswordValidation()
        let result = validate.Validate(password: self.passwordTextField.text ?? "", confirmPassword: self.confirmPasswordTextField.text ?? "")
        if result.success{
            return true
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [result.error ?? ""])
            return false
        }
    }
    
}
