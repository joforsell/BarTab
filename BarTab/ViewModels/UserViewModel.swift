//
//  UserViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-09.
//

import SwiftUI

struct UserViewModel {
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    
    func passwordsMatch(_confirmPassword: String) -> Bool {
        _confirmPassword == password
    }
    
    func isEmpty(_field: String) -> Bool {
        _field.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func isEmailValid(_email: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return passwordTest.evaluate(with: email)
    }
    
    func isPasswordValid(_password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    var isSignInComplete: Bool {
        if !isPasswordValid(_password: password) || !passwordsMatch(_confirmPassword: confirmPassword) {
            return false
        }
        return true
    }
    
    var isLoginComplete: Bool {
        if  isEmpty(_field: email) ||
                isEmpty(_field: password) {
            return false
        }
        return true
    }
        
    var validEmailAddressText: String {
        if isEmailValid(_email: email) {
            return ""
        } else {
            return "Skriv in giltig mailadress."
        }
    }
    
    var validPasswordText: String {
        if isPasswordValid(_password: password) {
            return ""
        } else {
            return "Lösenordet måste innehålla minst 8 tecken, varav ett nummer och en versal."
        }
    }
    
    var validConfirmPasswordText: String {
        if passwordsMatch(_confirmPassword: confirmPassword) {
            return ""
        } else {
            return "Lösenordsfälten matchar inte."
        }
    }
}
