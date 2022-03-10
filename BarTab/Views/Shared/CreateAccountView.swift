//
//  CreateAccountView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-21.
//

import SwiftUI
import SwiftUIX
import ToastUI

struct CreateAccountView: View {
    @EnvironmentObject var userHandler: UserHandling
    @EnvironmentObject var avoider: KeyboardAvoider
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var editingEmail = false
    @State private var editingPassword = false
    
    @State private var showingPassword = false
    @State private var isShowingAlert = false
    @State private var alertTitle: LocalizedStringKey = ""
    @State private var alertMessage: LocalizedStringKey = ""
    @State private var isShowingToast = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            KeyboardAvoiding(with: avoider) {
                Spacer()
                Image("beer")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .foregroundColor(.accentColor)
                Image("logotext")
                    .frame(width: 50)
                Spacer()
                emailInput
                passwordInput
                    .overlay(alignment: .trailing) {
                        Button {
                            showingPassword.toggle()
                        } label: {
                            Image(systemName: showingPassword ? "eye.fill" : "eye.slash.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                                .opacity(0.5)
                                .padding(10)
                        }
                        .offset(x: editingPassword ? 56 : 0)
                    }
                finishButton
                Spacer()
                HStack {
                    Link("Privacy policy", destination: URL(string: "https://bartab-d48b2.web.app/privacypolicy.html")!)
                    Spacer()
                    Link("Terms of use", destination: URL(string: "https://bartab-d48b2.web.app/termsandconditions.html")!)
                }
                .frame(width: 300)
                .padding(.vertical)
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(VisualEffectBlurView(blurStyle: .dark))
    }
    
    private var emailInput: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .bottom) {
                TextField("",
                          text: $email,
                          onEditingChanged: { editingChanged in
                    self.avoider.editingField = 12
                    if editingChanged {
                        withAnimation {
                            editingEmail = true
                        }
                    } else {
                        withAnimation {
                            editingEmail = false
                        }
                    } },
                          onCommit: {
                    withAnimation {
                        editingEmail.toggle()
                    }
                }
                )
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .font(.title3)
                Spacer()
            }
            .offset(y: 4)
            .overlay(alignment: .trailing) {
                Button {
                    UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
                } label: {
                    Image(systemName: editingEmail ? "checkmark.rectangle.fill" : "person.crop.square.filled.and.at.rectangle.fill")
                        .resizable()
                        .scaledToFit()
                        .opacity(editingEmail ? 1 : 0.5)
                        .foregroundColor(editingEmail ? .accentColor : .white)
                }
                .disabled(!editingEmail)
            }

            .overlay(alignment: .topLeading) {
                Text("E-mail address")
                    .font(.caption2)
                    .textCase(.uppercase)
                    .foregroundColor(.white)
                    .opacity(0.5)
                    .offset(y: -10)
            }
            
        }
        .frame(width: 300, height: 24)
        .padding()
        .foregroundColor(.white)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(6)
        .addBorder(editingEmail ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
        .avoidKeyboard(tag: 12)
        
    }
    
    private var passwordInput: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .bottom) {
                CocoaTextField("", text: $password) { editingChanged in
                    self.avoider.editingField = 13
                    if editingChanged {
                        withAnimation {
                            editingPassword = true
                        }
                    } else {
                        withAnimation {
                            editingPassword = false
                        }
                    }
                } onCommit: {
                    withAnimation {
                        editingPassword = false
                    }
                }
                .font(UIFont.preferredFont(forTextStyle: .title3))
                .foregroundColor(.white)
                .secureTextEntry(!showingPassword)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
                
                Spacer()
            }
            .offset(y: 4)
            .overlay(alignment: .trailing) {
                if editingPassword {
                    Button {
                        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
                    } label: {
                        Image(systemName: "checkmark.rectangle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .overlay(alignment: .topLeading) {
                Text("Password")
                    .font(.caption2)
                    .textCase(.uppercase)
                    .opacity(0.5)
                    .offset(y: -10)
            }
        }
        .frame(width: 300, height: 24)
        .padding()
        .foregroundColor(.white)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(6)
        .addBorder(editingPassword ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
        .avoidKeyboard(tag: 13)
        
    }
    
    private var finishButton: some View {
        Color.clear
            .frame(width: 300, height: 16)
            .padding()
            .overlay {
                Button {
                    if email.trimmingCharacters(in: .whitespaces).isEmpty {
                        alertTitle = "Please enter an e-mail address."
                        isShowingAlert = true
                    } else if password.trimmingCharacters(in: .whitespaces).isEmpty {
                        alertTitle = "Please enter a password."
                        isShowingAlert = true
                    } else {
                        UserHandling.createUser(withEmail: email, password: password) { error in
                            if let error = error {
                                alertTitle = "Could not create account."
                                alertMessage = error.errorDescription ?? "Unknown error."
                                isShowingAlert = true
                            }
                        }
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.accentColor)
                        .overlay {
                            Text("Create account")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .textCase(.uppercase)
                        }
                }
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }

    }
}
