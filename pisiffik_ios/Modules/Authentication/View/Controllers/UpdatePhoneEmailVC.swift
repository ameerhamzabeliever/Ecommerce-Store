//
//  UpdatePhoneEmailVC.swift
//  pisiffik_ios
//
//  Created by SA - Haider Ali on 12/06/2023.
//  Copyright © 2023 softwareAlliance. All rights reserved.
//

import UIKit
import PhoneNumberKit

enum UpdatePhoneEmailVCType{
    case phone
    case email
}

protocol UpdatePhoneEmailVCDelegates: AnyObject{
    func didUpdatePhoneEmail(type: UpdatePhoneEmailVCType,text: String,isValidNmb: Bool)
}

class UpdatePhoneEmailVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var phoneNmbBackView: UIView!
    @IBOutlet weak var phoneNmbLbl: UILabel!
    @IBOutlet weak var phoneNmbTextField: PhoneNumberTextField!
    @IBOutlet weak var emailBackView: UIView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    
    //MARK: - PROPERTIES -
    
    var mode: UpdatePhoneEmailVCType = {
        let mode: UpdatePhoneEmailVCType = .phone
        return mode
    }()
    
    weak var delegates: UpdatePhoneEmailVCDelegates?
    private var getPhoneNmb : String{
        return "+\(phoneNmbTextField.phoneNumber?.countryCode ?? 0)\(phoneNmbTextField.phoneNumber?.nationalNumber ?? 0)"
    }
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        configurePhoneNumberKit()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        titleLbl.text = PisiffikStrings.update()
        phoneNmbLbl.text = PisiffikStrings.mobileNumber()
        emailLbl.text = PisiffikStrings.email()
        updateBtn.setTitle(PisiffikStrings.update(), for: .normal)
        cancelBtn.setTitle(PisiffikStrings.cancel(), for: .normal)
    }
    
    func setUI() {
        self.phoneNmbTextField.textColor = .black
        self.emailTextField.textColor = .black
        if self.mode == .phone{
            self.phoneNmbBackView.isHidden = false
            self.emailBackView.isHidden = true
        }else{
            self.phoneNmbBackView.isHidden = true
            self.emailBackView.isHidden = false
        }
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func configurePhoneNumberKit(){
        phoneNmbTextField.withFlag = true
        phoneNmbTextField.withPrefix = true
        phoneNmbTextField.updateFlag()
        phoneNmbTextField.updatePlaceholder()
        phoneNmbTextField.flagButton.isUserInteractionEnabled = true
        phoneNmbTextField.withDefaultPickerUI = true
        phoneNmbTextField.withExamplePlaceholder = true
        phoneNmbTextField.addTarget(self, action: #selector(phoneTextChanged), for: .editingChanged)
    }
    
    @objc func phoneTextChanged(_ textField: UITextField) {
        if textField == phoneNmbTextField {
            if phoneNmbTextField.isValidNumber{
                phoneNmbTextField.textColor = .black
            }else{
                phoneNmbTextField.textColor = .red
            }
        }
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapCancelBtn(_ sender: UIButton){
        sender.showAnimation {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func didTapUpdateBtn(_ sender: UIButton){
        sender.showAnimation { [weak self] in
            guard let self = self else {return}
            if self.mode == .phone{
                self.delegates?.didUpdatePhoneEmail(type: .phone, text: self.getPhoneNmb, isValidNmb: self.phoneNmbTextField.isValidNumber)
            }else{
                self.delegates?.didUpdatePhoneEmail(type: .email, text: self.emailTextField.text?.replacingOccurrencesOfWhiteSpaces() ?? "", isValidNmb: true)
            }
            self.dismiss(animated: true)
        }
    }
    
    
}
