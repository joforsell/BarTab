//
//  SignUpView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-09.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var userInfo: UserInfo
    @State private var user: UserViewModel = UserViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var showError = false
    @State private var errorString = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    VStack(alignment: .leading) {
                        TextField("Användarnamn", text: self.$user.displayName).autocapitalization(.words).disableAutocorrection(true)
                        if !user.validNameText.isEmpty {
                            Text(user.validNameText).font(.caption).foregroundColor(.red)
                        }
                    }
                    VStack(alignment: .leading) {
                        TextField("Mailadress", text: self.$user.email).autocapitalization(.none).disableAutocorrection(true).keyboardType(.emailAddress)
                        if !user.validEmailAddressText.isEmpty {
                            Text(user.validEmailAddressText).font(.caption).foregroundColor(.red)
                        }
                    }
                    VStack(alignment: .leading) {
                        SecureField("Lösenord", text: self.$user.password)
                        if !user.validPasswordText.isEmpty {
                            Text(user.validPasswordText).font(.caption).foregroundColor(.red)
                        }
                    }
                    VStack(alignment: .leading) {
                        SecureField("Bekräfta lösenord", text: self.$user.confirmPassword)
                        if !user.passwordsMatch(_confirmPassword: user.confirmPassword) {
                            Text(user.validConfirmPasswordText).font(.caption).foregroundColor(.red)
                        }
                    }
                }
                .frame(width: 300)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                VStack(spacing: 20) {
                    Button(action: {
                        Authentication.createUser(withEmail: self.user.email, name: self.user.displayName, password: self.user.password) { result in
                            switch result {
                            case .failure(let error):
                                errorString = error.localizedDescription
                                showError = true
                            case .success( _):
                                print("Kontot skapades")
                            }
                        }
                    }) {
                        Text("Skapa konto")
                            .frame(width: 200)
                            .padding(.vertical, 15)
                            .background(Color.green)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .opacity(user.isSignInComplete ? 1 : 0.75)
                    }
                    .disabled(!user.isSignInComplete)
                    Spacer()
                }
                .padding()
            }
            .padding(.top)
            .alert(isPresented: $showError) {
                Alert(title: Text("Fel uppstod vid skapande av konto"), message: Text(errorString), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle("Skapa konto", displayMode: .inline)
            .navigationBarItems(trailing: Button("Stäng") {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
