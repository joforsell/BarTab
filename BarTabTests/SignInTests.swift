//
//  SignInTests.swift
//  SignInTests
//
//  Created by Johan Forsell on 2022-08-02.
//

import XCTest
@testable import BarTab

class SignInTests: XCTestCase {
    let vm = SignInViewModel()
    
    func testValidSignIn_GivesNoError() throws {
        // Given
        vm.email = "test@testing.now"
        vm.password = "123password"
        
        // When
        vm.handleSignInButton()
        
        // Then
        XCTAssertFalse(vm.isShowingAlert)
        XCTAssertEqual(vm.alertTitle, "")
        XCTAssertEqual(vm.alertMessage, "")
    }
    
    func testInvalidEmail_GivesEmailErrorMessage() throws {
        vm.email = "notanemail"
        vm.password = "123password"
        
        vm.handleSignInButton()
        
        XCTAssertTrue(vm.isShowingAlert)
        XCTAssertEqual(vm.alertTitle, "Please enter a valid e-mail address.")
    }
    
    func testEmptyEmail_GivesEmailErrorMessage() throws {
        vm.email = ""
        
        vm.handleSignInButton()
        
        XCTAssertTrue(vm.isShowingAlert)
        XCTAssertEqual(vm.alertTitle, "Please enter a valid e-mail address.")
    }
    
    func testEmptyPassword_GivesPasswordErrorMessage() throws {
        vm.email = "test@testing.com"
        vm.password = ""
        
        vm.handleSignInButton()
        
        XCTAssertTrue(vm.isShowingAlert)
        XCTAssertEqual(vm.alertTitle, "Please enter a password.")
    }
}
