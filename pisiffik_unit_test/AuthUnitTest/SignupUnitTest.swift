//
//  SignupUnitTest.swift
//  pisiffik_iosTests
//
//  Created by Haider Ali on 07/06/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import XCTest
@testable import pisiffik_ios


class SignupUnitTest: XCTestCase{
    
    func test_Full_Name_Should_Not_Be_Empty(){
        let request = SignupRequest(fullName: "", phone: "", password: "", deviceType: "", fcmToken: "")
        let result = SignupValidation().Validate(signupRequest: request, isValidPhone: true)
        XCTAssertEqual(result.success, false)
        XCTAssertEqual(result.error, R.string.localizable.signupFullNameIsEmpty())
    }
    
    func test_Full_Name_Length_Is_Not_Valid(){
        let request = SignupRequest(fullName: "r", phone: "", password: "", deviceType: "", fcmToken: "")
        let result = SignupValidation().Validate(signupRequest: request, isValidPhone: true)
        XCTAssertEqual(result.success, false)
        XCTAssertEqual(result.error, R.string.localizable.fullNameLenghtError())
    }
    
    func test_Full_Name_Is_Not_Valid(){
        let request = SignupRequest(fullName: "djsd1.2", phone: "", password: "", deviceType: "", fcmToken: "")
        let result = SignupValidation().Validate(signupRequest: request, isValidPhone: true)
        XCTAssertEqual(result.success, false)
        XCTAssertEqual(result.error, R.string.localizable.enterValidFullName())
    }
    
    func test_Phone_Nmb_Is_Empty(){
        let request = SignupRequest(fullName: "MHN", phone: "", password: "", deviceType: "", fcmToken: "")
        let result = SignupValidation().Validate(signupRequest: request, isValidPhone: true)
        XCTAssertEqual(result.success, false)
        XCTAssertEqual(result.error, R.string.localizable.loginPhoneIsEmpty())
    }
    
    func test_Phone_Nmb_Is_Not_Valid(){
        let request = SignupRequest(fullName: "MHN", phone: "+921215", password: "", deviceType: "", fcmToken: "")
        let result = SignupValidation().Validate(signupRequest: request, isValidPhone: false)
        XCTAssertEqual(result.success, false)
        XCTAssertEqual(result.error, R.string.localizable.loginPhoneIsInValid())
    }
    
    func test_Password_Is_Empty(){
        let request = SignupRequest(fullName: "MHN", phone: "03126578956", password: "", deviceType: "", fcmToken: "")
        let result = SignupValidation().Validate(signupRequest: request, isValidPhone: true)
        XCTAssertEqual(result.success, false)
        XCTAssertEqual(result.error, R.string.localizable.loginPasswordIsEmpty())
    }
    
    func test_Password_Length_Should_Be_Greater_Than_Six(){
        let request = SignupRequest(fullName: "MHN", phone: "03126578956", password: "1213", deviceType: "", fcmToken: "")
        let result = SignupValidation().Validate(signupRequest: request, isValidPhone: true)
        XCTAssertEqual(result.success, false)
        XCTAssertEqual(result.error, R.string.localizable.loginPasswordShouldBe6Characters())
    }
    
    func test_Device_Type_Required(){
        let request = SignupRequest(fullName: "MHN", phone: "03126578956", password: "12131232", deviceType: "", fcmToken: "")
        let result = SignupValidation().Validate(signupRequest: request, isValidPhone: true)
        XCTAssertEqual(result.success, false)
        XCTAssertEqual(result.error, R.string.localizable.deviceTypeRequired())
    }
    
    func test_FcmToken_Required(){
        let request = SignupRequest(fullName: "MHN", phone: "03126578956", password: "12131213", deviceType: "iOS", fcmToken: "")
        let result = SignupValidation().Validate(signupRequest: request, isValidPhone: true)
        XCTAssertEqual(result.success, false)
        XCTAssertEqual(result.error, R.string.localizable.fcmTokenRequired())
    }
    

    
}
