//
//  SignInWithEmailView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-09.
//

import SwiftUI

struct SignInWithEmailView: View {
    @EnvironmentObject var userInfo: UserInfo
    @State var user: UserViewModel = UserViewModel()
    @Binding var showSheet: Bool
    @Binding var action: LoginView.Action?
    
    @State private var showAlert = false
    @State private var authError: EmailAuthError?
    
    var body: some View {
        VStack {
            TextField("Mailadress", text: $user.email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
            SecureField("Lösenord", text: $user.password)
            HStack {
                Spacer()
                Button(action: {
                    self.action = .resetPassword
                    self.showSheet = true
                }) {
                    Text("Glömt lösenordet")
                }
            }.padding(.bottom)
            VStack(spacing: 10) {
                Button(action: {
                    Authentication.authenticate(withEmail: self.user.email, password: self.user.password) { result in
                        switch result {
                        case .failure(let error):
                            self.authError = error
                            self.showAlert = true
                        case .success( _):
                            print("Inloggad")
                        }
                    }
                }) {
                    Text("Logga in")
                        .padding(.vertical, 15)
                        .frame(width: 200)
                        .background(Color.green)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .opacity(user.isLoginComplete ? 1 : 0.7)
                }.disabled(!user.isLoginComplete)
                Button(action: {
                    self.action = .signUp
                    self.showSheet = true
                }) {
                    Text("Skapa konto")
                        .padding(.vertical, 15)
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Fel vid inloggning"), message: Text(self.authError?.localizedDescription ?? "Okänt fel"), dismissButton: .default(Text("OK")) {
                    if self.authError == .incorrectPassword {
                        self.user.password = ""
                    } else {
                        self.user.password = ""
                        self.user.email = ""
                    }
                })
            }
        }
        .padding(.top, 100)
        .frame(width: 300)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct SignInWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithEmailView(showSheet: .constant(true), action: .constant(nil))
    }
}
