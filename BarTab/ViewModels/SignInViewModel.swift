//
//  SignInViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-08-02.
//

import Foundation
import SwiftUI

class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    @Published var editingEmail = false
    @Published var editingPassword = false
    
    @Published var showingPassword = false
    @Published var isShowingAlert = false
    @Published var alertTitle: LocalizedStringKey = ""
    @Published var alertMessage: LocalizedStringKey = ""
    @Published var isShowingCreateAccountView = false
    
    func handleResetPassword() {
        UserHandling.resetPassword(for: email) { [weak self] error in
            if let error = error {
                self?.alertTitle = "Could not send new password."
                self?.alertMessage = error.localizedErrorDescription ?? "Unknown error."
                self?.isShowingAlert = true
            }
        }
    }
    
    func handleSignInButton() {
        if email.trimmingCharacters(in: .whitespaces).isEmpty || !validateEmail(email: email) {
            alertTitle = "Please enter a valid e-mail address."
            isShowingAlert = true
        } else if password.trimmingCharacters(in: .whitespaces).isEmpty {
            alertTitle = "Please enter a password."
            isShowingAlert = true
        } else {
            UserHandling.signIn(withEmail: email, password: password) { [weak self] error in
                if let error = error {
                    self?.alertTitle = "Could not sign in."
                    self?.alertMessage = error.localizedErrorDescription ?? "Unknown error."
                    self?.isShowingAlert = true
                }
            }
        }
    }
    
    private func validateEmail(email: String) -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let valid = email.range(of: emailPattern, options: .regularExpression)
        return valid != nil
    }
}
