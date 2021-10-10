//
//  LoginView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-09.
//

import SwiftUI

struct LoginView: View {
    enum Action {
        case signUp, resetPassword
    }
    
    @State private var showSheet = false
    @State private var action: Action?
    
    var body: some View {
        SignInWithEmailView(showSheet: $showSheet, action: $action)
            .sheet(isPresented: $showSheet) {
                if self.action == .signUp {
                    SignUpView()
                } else {
                    ForgotPasswordView()
                }
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
