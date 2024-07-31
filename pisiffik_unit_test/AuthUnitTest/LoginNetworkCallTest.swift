//
//  LoginNetworkCallTest.swift
//  pisiffik_iosTests
//
//  Created by Haider Ali on 20/07/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import XCTest
@testable import pisiffik_ios

class LoginNetworkCallTest: XCTestCase {

    func test_LoginApiResource_With_ValidRequest_Return_LoginResponse(){
        
        let resource = LoginResource()
        let request = LoginValidationRequest(phone: "+923124573059", password: "12345678")
        let expectations = self.expectation(description: "ValidRequest_Return_LoginResponse")
        
        resource.loginUser(loginRequest: request) { result, statusCode  in
            
            XCTAssertEqual(statusCode, 200)
            XCTAssertEqual(request.phone, result?.data?.user?.phone)
            XCTAssertNotNil(result?.data?.user)
            XCTAssertEqual(result?.responseCode, 1)
            XCTAssertNil(result?.error)
            
            expectations.fulfill()
            
        }
        
        waitForExpectations(timeout: 60.0, handler: nil)
        
    }

}
