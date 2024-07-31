//
//  ForgotPasswordValidationTest.swift
//  pisiffik_iosTests
//
//  Created by Haider Ali on 01/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import XCTest
@testable import pisiffik_ios

class ForgotPasswordValidationTest: XCTestCase {

    func test_Both_Password_Should_Not_Be_Empty(){
        
        let validate = ResetPasswordValidation()
        let result = validate.Validate(password: "", confirmPassword: "")
        XCTAssertEqual(result.success, false)
        
    }
    
    func test_Password_Should_Not_Be_Empty(){
        let validate = ResetPasswordValidation()
        let result = validate.Validate(password: "", confirmPassword: "3212")
        XCTAssertEqual(result.success, false)
        XCTAssertEqual(result.error, R.string.localizable.passwordFieldIsEmpty())
    }
    
    func test_Password_Should_Be_Greater_Than_Six(){
        let validate = ResetPasswordValidation()
        let result = validate.Validate(password: "2123", confirmPassword: "3212")
        XCTAssertEqual(result.success, false)
        XCTAssertEqual(result.error, R.string.localizable.passwordShouldBe6Characters())
    }
    
    func test_Confirm_Password_Should_Not_Be_Empty(){
        let validate = ResetPasswordValidation()
        let result = validate.Validate(password: "12345678", confirmPassword: "")
        XCTAssertEqual(result.success, false)
        XCTAssertEqual(result.error, R.string.localizable.confirmPasswordFieldIsEmpty())
    }
    
    func test_Confirm_Password_Should_Be_Greater_Than_Six(){
        let validate = ResetPasswordValidation()
        let result = validate.Validate(password: "12345678", confirmPassword: "3212")
        XCTAssertEqual(result.success, false)
        XCTAssertEqual(result.error, R.string.localizable.confirmPasswordShouldBe6Characters())
    }
    
    func test_Both_Password_Should_Be_Matched(){
        let validate = ResetPasswordValidation()
        let result = validate.Validate(password: "12345678", confirmPassword: "12345698")
        XCTAssertEqual(result.success, false)
        XCTAssertEqual(result.error, R.string.localizable.bothPasswordMustBeMatced())
    }

}
