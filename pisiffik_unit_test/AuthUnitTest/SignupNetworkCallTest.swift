//
//  SignupNetworkCallTest.swift
//  pisiffik_iosTests
//
//  Created by Haider Ali on 01/08/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import XCTest
@testable import pisiffik_ios

class SignupNetworkCallTest: XCTestCase {

    func test_Resgister_New_User(){
        
        let resource = SignupResource()
        let request = SignupRequest(fullName: "Muhammad Hamza", phone: "+923124573059", password: "12345678", deviceType: "iOS", fcmToken: "jbdjfdfgfdjfdjfdjsfjdkshfkjds")
        let expectations = self.expectation(description: "Resgister_New_User")
        
        resource.registerUser(signupRequest: request) { result, statusCode in
            
            XCTAssertEqual(statusCode, 200)
            XCTAssertNotNil(result?.data?.user)
            XCTAssertEqual(result?.responseCode, 1)
            XCTAssertNil(result?.error)
            
            expectations.fulfill()
        }
        
        waitForExpectations(timeout: 60.0, handler: nil)
        
    }
    
    func test_Verify_User(){
        
        let resource = SignupResource()
        let request = VerifyPhoneRequest(otp: "324408", phone: "+923124573059")
        let expectations = self.expectation(description: "Verify_User")
        
        resource.verifyUser(verifyRequest: request) { result, statusCode in
            
            XCTAssertEqual(statusCode, 200)
            XCTAssertEqual(result?.responseCode, 1)
            XCTAssertNotNil(result?.data?.accessToken)
            XCTAssertNil(result?.error)
            
            expectations.fulfill()
        }
        
        waitForExpectations(timeout: 60.0, handler: nil)
        
    }

}
