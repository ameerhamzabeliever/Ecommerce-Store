//
//  ProfileTabVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 02/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit
import CoreLocation

class ProfileTabVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var profileTableView: UITableView!{
        didSet{
            profileTableView.delegate = self
            profileTableView.dataSource = self
            profileTableView.register(R.nib.profileCell)
        }
    }
    
    
    
    //MARK: - PROPERTIES -
    
    private var profileTabs : [ProfileTabModel] = [ProfileTabModel]()
    private var logoutViewModel = LogoutViewModel()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        logoutViewModel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setText()
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        self.profileTabs = [
            ProfileTabModel(image: R.image.ic_my_profile(), name: PisiffikStrings.profile(), secondImage: R.image.ic_forward_icon()),
//            ProfileTabModel(image: R.image.ic_location_icon(), name: PisiffikStrings.deliveryAddress(), secondImage: R.image.ic_forward_icon()),
//            ProfileTabModel(image: R.image.ic_my_payment_method_icon(), name: PisiffikStrings.paymentMethod(), secondImage: R.image.ic_forward_icon()),
            ProfileTabModel(image: R.image.ic_my_inbox(), name: PisiffikStrings.inbox(), secondImage: R.image.ic_forward_icon()),
            ProfileTabModel(image: R.image.ic_my_purchase(), name: PisiffikStrings.purchase(), secondImage: R.image.ic_forward_icon()),
            ProfileTabModel(image: R.image.ic_my_points(), name: PisiffikStrings.points(), secondImage: R.image.ic_forward_icon()),
            ProfileTabModel(image: R.image.ic_my_favorites(), name: PisiffikStrings.favorites(), secondImage: R.image.ic_forward_icon()),
            ProfileTabModel(image: R.image.ic_my_offer_benifits(), name: PisiffikStrings.offersAndBenefits(), secondImage: R.image.ic_forward_icon()),
            ProfileTabModel(image: R.image.ic_my_preferences(), name: PisiffikStrings.preferences(), secondImage: R.image.ic_forward_icon()),
//            ProfileTabModel(image: R.image.ic_my_membership(), name: PisiffikStrings.membership(), secondImage: R.image.ic_forward_icon()),
            ProfileTabModel(image: nil, name: PisiffikStrings.customerService(), secondImage: nil),
            ProfileTabModel(image: nil, name: PisiffikStrings.aboutPisiffik(), secondImage: nil),
            ProfileTabModel(image: nil, name: PisiffikStrings.termsAndConditions(), secondImage: nil),
            ProfileTabModel(image: nil, name: PisiffikStrings.rateOurApp(), secondImage: nil),
            ProfileTabModel(image: nil, name: PisiffikStrings.findStore(), secondImage: nil),
            ProfileTabModel(image: nil, name: PisiffikStrings.privacyPolicy(), secondImage: nil),
            ProfileTabModel(image: nil, name: PisiffikStrings.gdpr(), secondImage: nil),
            ProfileTabModel(image: nil, name: PisiffikStrings.logout(), secondImage: nil)
        ]
        guard let currentUser = DBUserManagerRepository().getUser(),
              let fullName = currentUser.fullName
        else {
            return
        }
        titleLbl.text = PisiffikStrings.hi() + " " + fullName
        DispatchQueue.main.async { [weak self] in
            self?.profileTableView.reloadData()
        }
    }
    
    func setUI() {
        titleLbl.font = Fonts.mediumFontsSize20
        titleLbl.textColor = .white
        titleLbl.numberOfLines = 1
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    //MARK: - ACTIONS -
    
    @IBAction func didTapProfileBtn(_ sender: UIButton) {
        sender.showAnimation {
            self.navigateToMyProfileVC()
        }
    }
    
    
}


//MARK: - EXTENSION FOR TABLE VIEW CELLS -

extension ProfileTabVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileTabs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureProfileCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.profileTableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row{
        case 0:
            self.navigateToMyProfileVC()
//        case 1:
//            self.navigateToDeliveryAddressVC()
//        case 2:
//            self.navigateToAddPaymentCardVC()
        case 1:
            self.navigateToMyInboxVC()
        case 2:
            self.navigateToMyPurchasesVC()
        case 3:
            self.navigateToMyPointsVC()
        case 4:
            self.navigateToMyFavoritesVC()
        case 5:
            self.navigateToMyOfferAndBenefitVC()
        case 6:
            self.navigateToPreferenceVC()
//        case 9:
//            self.navigateToMembershipVC()
        case 7:
            self.navigateToContactUsVC()
        case 8:
            self.navigateToAboutUsVC()
        case 9:
            self.navigateToTermsOfUseVC()
        case 10:
            self.navigateToAppStore()
        case 11:
            self.navigateToFindStoresVC()
        case 12:
            self.navigateToPrivacyPolicyVC()
        case 13:
            self.openGDPR()
        case 14:
            self.logoutUser()
        default:
            Constants.printLogs("********")
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 6{
            return 40.0
        }else{
            return 60.0
        }
    }
    
}


//MARK: - EXTENSION FOR PROFILE CELL -

extension ProfileTabVC{
    
    fileprivate func configureProfileCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = profileTableView.dequeueReusableCell(withIdentifier: .profileCell, for: indexPath) as! ProfileCell
        
        let obj = self.profileTabs[indexPath.row]
        
        cell.nameLbl.text = obj.name
        
        if indexPath.row > 6{
            cell.backView.backgroundColor = R.color.cardColor()
            cell.seperator.isHidden = true
            cell.widthConstrain.constant = 0.0
            cell.nameLbl.textColor = R.color.darkFontColor()
            cell.leadingImage.isHidden = true
            cell.trailingImage.isHidden = true
        }else{
            cell.backView.backgroundColor = R.color.backgroundColor()
            cell.widthConstrain.constant = 35.0
            cell.nameLbl.textColor = R.color.textBlackColor()
            if indexPath.row == 6{
                cell.seperator.isHidden = true
            }else{
                cell.seperator.isHidden = false
            }
            cell.leadingImage.isHidden = false
            cell.trailingImage.isHidden = false
        }
        
        if let firstImage = obj.image, let secImage = obj.secondImage{
            cell.leadingImage.image = firstImage
            cell.trailingImage.image = secImage
        }
        
        return cell
    }
    
    
}

//MARK: - EXTENSION FOR LOGOUT VIEW MODEL DELEGATES -

extension ProfileTabVC: LogoutViewModelDelegates{
    
    func didReceiveLogout(response: BaseResponse) {
        
    }
    
    func didReceiveLogoutResponseWith(errorMessage: [String]?, statusCode: Int?) {
        self.showAlert(title: PisiffikStrings.alert(), errorMessages: errorMessage)
    }
    
}



//MARK: -  EXTENSION FOR NAVIAGATION FUNCTIONS -

extension ProfileTabVC: StoreHelpVCDelegates{
    
    fileprivate func navigateToMyProfileVC(){
        guard let myProfileVC = R.storyboard.profileSB.myProfileVC() else {return}
        self.push(controller: myProfileVC, hideBar: true, animated: true)
    }
    
    fileprivate func navigateToDeliveryAddressVC(){
        guard let deliveryAddressVC = R.storyboard.addressSB.deliveryAddressVC() else {return}
        self.push(controller: deliveryAddressVC, hideBar: true, animated: true)
    }
    
    fileprivate func navigateToAddPaymentCardVC(){
        //Check if already card add go to card vc otherwise go to no card added vc
        guard let noPaymentCardVC = R.storyboard.homeSB.noPaymentCardVC() else {return}
        self.push(controller: noPaymentCardVC, hideBar: true, animated: true)
    }
    
    fileprivate func navigateToMyInboxVC(){
        guard let inboxVC = R.storyboard.profileSB.inboxVC() else {return}
        self.push(controller: inboxVC, hideBar: true, animated: true)
    }
    
    fileprivate func navigateToMyPurchasesVC(){
        guard let myPurchasesVC = R.storyboard.profileSB.myPurchasesVC() else {return}
        self.push(controller: myPurchasesVC, hideBar: true, animated: true)
    }
    
    fileprivate func navigateToMyPointsVC(){
        guard let myPointsVC = R.storyboard.profileSB.myPointsVC() else {return}
        self.push(controller: myPointsVC, hideBar: true, animated: true)
    }
    
    fileprivate func navigateToMyFavoritesVC(){
        guard let myFavoritesVC = R.storyboard.profileSB.myFavoritesVC() else {return}
        self.push(controller: myFavoritesVC, hideBar: true, animated: true)
    }
    
    fileprivate func navigateToMyOfferAndBenefitVC(){
        guard let myOfferAndBenefitVC = R.storyboard.homeOffersSB.myOfferAndBenefitVC() else {return}
        myOfferAndBenefitVC.mode = .fromProfile
        self.push(controller: myOfferAndBenefitVC, hideBar: true, animated: true)
    }
    
    fileprivate func navigateToPreferenceVC() {
        guard let prefVC = R.storyboard.preferencesSB.preferenceVC() else {
            return
        }
        self.push(controller: prefVC, hideBar: true, animated: true)
    }
    
    fileprivate func navigateToMembershipVC() {
        guard let membershipVC = R.storyboard.membershipSB.membershipVC() else {
            return
        }
        self.push(controller: membershipVC, hideBar: true, animated: true)
    }
    
    fileprivate func navigateToContactUsVC() {
        guard let contactUsVC = R.storyboard.contactServiceSB.contactUsVC() else {
            return
        }
        self.push(controller: contactUsVC, hideBar: true, animated: true)
    }
    
    fileprivate func navigateToAboutUsVC() {
        guard let aboutUsVC = R.storyboard.privacySB.privacyVC() else {
            return
        }
        aboutUsVC.mode = .about
        self.push(controller: aboutUsVC, hideBar: true, animated: true)
    }
    
    fileprivate func navigateToTermsOfUseVC() {
        guard let termsOfUse = R.storyboard.privacySB.privacyVC() else {
            return
        }
        termsOfUse.mode = .termsOfUse
        self.push(controller: termsOfUse, hideBar: true, animated: true)
    }
    
    fileprivate func navigateToAppStore(){
        if let url = URL(string: Constants.AppStoreLink) {
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url)
            }
        }
    }
    
    fileprivate func navigateToFindStoresVC(){
        if !LocationManager.shared.userDeniedLocation{
            guard let findStoreVC = R.storyboard.profileSB.findStoreVC() else {return}
            self.push(controller: findStoreVC, hideBar: true, animated: true)
        }else{
            self.showAlert(title: PisiffikStrings.alert(),description: PisiffikStrings.enableLocationStoreDirectionAlertMessage(), cancelBtnHide: false, delegate: self)
        }
    }
    
    func didTapAlertDoneBtn(alertType: AlertType) {
        Utils.shared.goToAndEnableLocation()
    }
    
    fileprivate func navigateToPrivacyPolicyVC() {
        guard let privacyVC = R.storyboard.privacySB.privacyVC() else {
            return
        }
        privacyVC.mode = .privacy
        self.push(controller: privacyVC, hideBar: true, animated: true)
    }
    
    private func openGDPR(){
        if let currentUser = DBUserManagerRepository().getUser(){
            if let gdprURL = URL(string: "\(Constants.GDPR)\(currentUser.id ?? "")"){
                Constants.printLogs("GDPR: \(gdprURL)")
                UIApplication.shared.open(gdprURL)
            }
        }
    }
    
    private func logoutUser(){
        if Network.isAvailable{
            UserDefault.shared.saveNotificationBadge(count: 0)
            UserDefault.shared.deleteAllNotificationsID()
            UIApplication.shared.applicationIconBadgeNumber = 0
            self.logoutViewModel.logoutUser()
            DBUserManagerRepository().deleteAllRecord()
            EventLocalManager.shared.deleteAllLocalEvent()
            NewsLocalManager.shared.deleteAllNewsID()
            EventIDLocalManager.shared.deleteAllEventID()
            UserDefault.shared.saveMedia(url: "")
            if let welcomeBoard = R.storyboard.authSB.authNavigationVC() {
                UIApplication.shared.windows.first?.rootViewController = welcomeBoard
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }else{
            self.showAlert(title: PisiffikStrings.alert(), errorMessages: [PisiffikStrings.oopsNoInternetConnection()])
        }
    }

    
}
