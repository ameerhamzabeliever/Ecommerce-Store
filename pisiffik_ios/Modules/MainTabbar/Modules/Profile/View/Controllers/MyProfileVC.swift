//
//  MyProfileVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 06/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import PhoneNumberKit
import Localize_Swift
import IQDropDownTextField

class MyProfileVC: BaseVC {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var languageBtn: UIButton!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var phoneNmbTextField: PhoneNumberTextField!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var validEmailIcon: UIImageView!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateOfBirthLbl: UILabel!
    @IBOutlet weak var dateOfBirthTextField: IQDropDownTextField!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var updateBtn: LoadingButton!
    
    //MARK: - PROPERTIES -
    
    private var viewModel = MyProfileViewModel()
    private var genderID : Int = 0
    private var dateOfBirth : String = ""
    
    private let datePickerView : UIDatePicker = {
        let picker = UIDatePicker()
        let calender = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calender
        components.year = -5
        let maxDate = calender.date(byAdding: components, to: currentDate)
        components.year = -100
        let minDate = calender.date(byAdding: components, to: currentDate)
        picker.minimumDate = minDate
        picker.maximumDate = maxDate
        return picker
    }()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        configurePhoneNumberKit()
        viewModel.delegate = self
        nameTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.phoneNmbTextField.isEnabled = false
        
        if let user = DBUserManagerRepository().getUser(){
            if let userEmailVerified = user.emailVerifiedAt{
                if userEmailVerified.isEmpty{
                    validEmailIcon.isHidden = true
                }else{
                    validEmailIcon.isHidden = false
                }
            }else{
                validEmailIcon.isHidden = true
            }
        }
        
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        if let user = DBUserManagerRepository().getUser(){
            phoneNmbTextField.text = user.phone ?? ""
            emailTextField.text = user.email ?? ""
            nameTextField.text = user.fullName ?? ""
            if let genderID = user.gender?.id{
                if genderID == 1{
                    genderTextField.text = PisiffikStrings.male()
                }else if genderID == 2{
                    genderTextField.text = PisiffikStrings.female()
                }else if genderID == 3{
                    genderTextField.text = PisiffikStrings.other()
                }
                self.genderID = genderID
            }
            if let dob = user.dob{
                dateOfBirthTextField.selectedItem = dob
                self.dateOfBirth = dob
            }
        }
        titleLbl.text = PisiffikStrings.profile()
        mobileNumberLbl.text = PisiffikStrings.mobileNumber()
        emailLbl.text = PisiffikStrings.email()
        emailTextField.placeholder = PisiffikStrings.emailPlaceHolder()
        fullNameLbl.text = PisiffikStrings.fullName()
        dateOfBirthLbl.text = PisiffikStrings.dateOfBirth()
        genderLbl.text = PisiffikStrings.gender()
        updateBtn.setTitle(PisiffikStrings.update(), for: .normal)
        getCurrentLanguage()
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = R.color.textWhiteColor()
        languageBtn.titleLabel?.font = Fonts.mediumFontsSize12
        languageBtn.setTitleColor(R.color.textWhiteColor(), for: .normal)
        mobileNumberLbl.font = Fonts.mediumFontsSize14
        mobileNumberLbl.textColor = R.color.textBlueColor()
        phoneNmbTextField.font = Fonts.regularFontsSize14
        phoneNmbTextField.textColor = R.color.textBlackColor()
        emailLbl.font = Fonts.mediumFontsSize14
        emailLbl.textColor = R.color.textBlueColor()
        emailTextField.font = Fonts.regularFontsSize14
        emailTextField.textColor = R.color.textBlackColor()
        validEmailIcon.isHidden = true
        fullNameLbl.font = Fonts.mediumFontsSize14
        fullNameLbl.textColor = R.color.textBlueColor()
        nameTextField.font = Fonts.regularFontsSize14
        dateOfBirthLbl.font = Fonts.mediumFontsSize14
        dateOfBirthLbl.textColor = R.color.textBlueColor()
        dateOfBirthTextField.font = Fonts.regularFontsSize14
        genderLbl.font = Fonts.mediumFontsSize14
        genderLbl.textColor = R.color.textBlueColor()
        genderTextField.font = Fonts.regularFontsSize14
        updateBtn.titleLabel?.font = Fonts.mediumFontsSize14
        configureDatePickerView()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func configurePhoneNumberKit(){
        phoneNmbTextField.withFlag = true
        phoneNmbTextField.withPrefix = false
        phoneNmbTextField.updateFlag()
        phoneNmbTextField.updatePlaceholder()
        phoneNmbTextField.flagButton.isUserInteractionEnabled = false
        phoneNmbTextField.withDefaultPickerUI = true
        phoneNmbTextField.withExamplePlaceholder = true
    }
    
    private func configureDatePickerView(){
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateOfBirthTextField.dropDownMode = .datePicker
        dateOfBirthTextField.dateFormatter = dateFormatter
        dateOfBirthTextField.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -5, to: Date())
    }
    
    private func navigateToCountryVCWith(id: Int = 0,mode: CountryMode){
        guard let countryVC = R.storyboard.profileSB.countryVC() else {return}
        countryVC.currentID = id
        countryVC.mode = mode
        self.push(controller: countryVC, hideBar: true, animated: true)
    }
    
    private func getUserData(user: UserData,accessToken: String,emailVerifiedAt: String?) -> UserData{
        return UserData(id: user.id, fullName: user.fullName, phone: user.phone, email: user.email, fcmToken: user.fcmToken, emailVerifiedAt: emailVerifiedAt, dob: user.dob, country: Description(id: user.country?.id, name: user.country?.name), gender: Description(id: user.gender?.id, name: user.gender?.name), state: Description(id: user.state?.id, name: user.state?.name), city: Description(id: user.city?.id, name: user.city?.name), address: user.address, deviceType: user.deviceType, latitude: user.latitude, longitude: user.longitude, otp: user.otp, isVerified: user.isVerified, rememberToken: user.rememberToken, deletedAt: user.deletedAt, createdAt: user.createdAt, updatedAt: user.updatedAt, token: accessToken,phoneVerify: user.phoneVerify,emailVerify: user.emailVerify)
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapLanguageBtn(_ sender: UIButton) {
        sender.showAnimation {
            guard let languageVC = R.storyboard.languageBoard.languageVC() else {return}
            languageVC.mode = .fromMyProfile
            self.push(controller: languageVC, hideBar: true, animated: true)
        }
    }
    
    @IBAction func didTapGenderSelectionBtn(_ sender: UIButton) {
        guard let genderVC = R.storyboard.profileSB.genderSelectionVC() else {return}
        genderVC.delegate = self
        self.present(genderVC, animated: true)
    }
    
    
    @IBAction func didTapUpdateBtn(_ sender: UIButton) {
        sender.showAnimation {
            if !self.updateBtn.isAnimating{
                self.updateBtn.showLoading()
                self.viewModel.updateProfileWith(name: self.nameTextField.text ?? "", dob: self.dateOfBirthTextField.selectedItem ?? self.dateOfBirth , genderID: self.genderID ,email: self.emailTextField.text)
            }
        }
    }
    
}

//MARK: - EXTENSION FOR MYPROFILE VIEW MODEL DELEGATE -

extension MyProfileVC: MyProfileViewModelDelegate{
    
    func didReceiveUpdateProfile(response: UpdateProfileResponse) {
        self.updateBtn.hideLoading()
        guard let oldUser = DBUserManagerRepository().getUser() else {return}
        if let user = response.data?.user, let accessToken = oldUser.token{
            DBUserManagerRepository().create(record: getUserData(user: user, accessToken: accessToken, emailVerifiedAt: user.emailVerifiedAt))
        }
        self.showAlert(title: PisiffikStrings.success(), description: response.responseMessage ?? "", delegate: self)
    }
    
    func didReceiveUpdateProfileResponseWith(errorMessage: [String]?, statusCode: Int?) {
        self.updateBtn.hideLoading()
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
    
    func didReceiveUnauthentic(error: [String]?) {
        self.updateBtn.hideLoading()
        RootRouter().logoutUserIsUnAutenticated()
    }
    
    func didReceiveServer(error: [String]?, type: String, indexPath: Int) {
        self.updateBtn.hideLoading()
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: error)
    }
    
}


//MARK: -  EXTENSION FOR GENDER SELECTION DELEGATES - 

extension MyProfileVC: GenderSelectionProtocol{
    
    func didSelectGenderOf(type: String, id: Int) {
        self.genderTextField.text = type
        self.genderID = id
    }
    
}



//MARK: -  EXTENSION FOR LanguageSelectionDelegates -

extension MyProfileVC{
    
    private func getCurrentLanguage(){
        if Localize.currentLanguage() == .danish{
            self.languageBtn.setTitle(PisiffikStrings.danish(), for: .normal)
            self.languageBtn.setImage(R.image.flag_of_Denmark(), for: .normal)
        }else if Localize.currentLanguage() == .greenland{
            self.languageBtn.setTitle(PisiffikStrings.greenland(), for: .normal)
            self.languageBtn.setImage(R.image.flag_of_Greenland(), for: .normal)
        }else{
            self.languageBtn.setTitle(PisiffikStrings.english(), for: .normal)
            self.languageBtn.setImage(R.image.flag_of_the_United_States(), for: .normal)
        }
    }
    
}


//MARK: - EXTENSION FOR ALERT VC DELEGATES -

extension MyProfileVC: StoreHelpVCDelegates{
    
    func didTapAlertDoneBtn(alertType: AlertType) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - EXTENSION FOR UITextFieldDelegate -

extension MyProfileVC: UITextFieldDelegate{
    
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
