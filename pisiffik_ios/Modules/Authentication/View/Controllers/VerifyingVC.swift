//
//  VerifyingVC.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 30/05/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import UIKit

class VerifyingVC: UIViewController {
    
    //MARK: - OUTLET -
    
    @IBOutlet weak var verifyLbl : UILabel!
    
    //MARK: - PROPERTIES -
    
    var phoneNmb : String = ""
    var email: String = ""
    var otp : String = ""
    var user : UserData?
    
    var mode : SignMode = {
        let mode : SignMode = .fromSignup
        return mode
    }()
    
    //MARK: - LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        verifyOTP()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - METHODS -
    
    @objc func setText(){
        verifyLbl.text = "\(PisiffikStrings.verifying())..."
    }
    
    func setUI() {
        verifyLbl.font = Fonts.regularFontsSize20
        verifyLbl.textColor = .white
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageChanged, object: nil)
    }
    
    private func verifyOTP(){
        
    }
    
    
    
    //MARK: - ACTIONS -
    
    
    
}


/*
 private func getUserData(user: UserData,accessToken: String) -> UserData{
     return UserData(id: user.id, fullName: user.fullName, phone: user.phone, email: user.email, fcmToken: user.fcmToken, emailVerifiedAt: user.emailVerifiedAt, dob: user.dob, country: Description(id: user.country?.id, name: user.country?.name), gender: Description(id: user.gender?.id, name: user.gender?.name), state: Description(id: user.state?.id, name: user.state?.name), city: Description(id: user.city?.id, name: user.city?.name), address: user.address, deviceType: user.deviceType, latitude: user.latitude, longitude: user.longitude, otp: user.otp, isVerified: user.isVerified, rememberToken: user.rememberToken, deletedAt: user.deletedAt, createdAt: user.createdAt, updatedAt: user.updatedAt, token: accessToken)
 }
 
 private func getUserData(user: UserData,email: String,verifiedAt: String) -> UserData{
     return UserData(id: user.id, fullName: user.fullName, phone: user.phone, email: email, fcmToken: user.fcmToken, emailVerifiedAt: verifiedAt, dob: user.dob, country: Description(id: user.country?.id, name: user.country?.name), gender: Description(id: user.gender?.id, name: user.gender?.name), state: Description(id: user.state?.id, name: user.state?.name), city: Description(id: user.city?.id, name: user.city?.name), address: user.address, deviceType: user.deviceType, latitude: user.latitude, longitude: user.longitude, otp: user.otp, isVerified: user.isVerified, rememberToken: user.rememberToken, deletedAt: user.deletedAt, createdAt: user.createdAt, updatedAt: user.updatedAt, token: user.token)
 }
 */
