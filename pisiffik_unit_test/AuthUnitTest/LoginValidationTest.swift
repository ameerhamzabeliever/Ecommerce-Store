//
//  LoginValidationTest.swift
//  pisiffik_iosTests
//
//  Created by Haider Ali on 25/05/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import XCTest
@testable import pisiffik_ios

class LoginValidationTest: XCTestCase {

    func test_LoginValidation_EmptyFields_Returns_False(){
        
        let validate = LoginValidation()
        let request = LoginValidationRequest(phone: "", password: "")
        let result = validate.Validate(loginRequest: request)
        XCTAssertEqual(result.success, false)
        
    }
    
    func test_LoginValidation_PhoneField_Returns_False(){
        
        let validate = LoginValidation()
        let request = LoginValidationRequest(phone: "", password: "2434354")
        let result = validate.Validate(loginRequest: request)
        XCTAssertNotNil(result.error, R.string.localizable.loginPhoneIsEmpty())
        
    }
    
    func test_LoginValidation_PasswordField_Returns_False(){
        
        let validate = LoginValidation()
        let request = LoginValidationRequest(phone: "4343243", password: "")
        let result = validate.Validate(loginRequest: request)
        XCTAssertNotNil(result.error, R.string.localizable.loginPasswordIsEmpty())
        
    }
    
    func test_LoginValidation_PasswordLength_ShouldBe_GreaterThanSix_Returns_False(){
        
        let validate = LoginValidation()
        let request = LoginValidationRequest(phone: "4343243", password: "4324")
        let result = validate.Validate(loginRequest: request)
        XCTAssertEqual(result.success, false)
        
    }
    

}
