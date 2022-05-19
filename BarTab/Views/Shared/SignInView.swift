//
//  SignInView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-01-22.
//

import SwiftUI
import SwiftUIX

struct SignInView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @EnvironmentObject var avoider: KeyboardAvoider
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var editingEmail = false
    @State private var editingPassword = false
    
    @State private var showingPassword = false
    @State private var isShowingAlert = false
    @State private var alertTitle: LocalizedStringKey = ""
    @State private var alertMessage: LocalizedStringKey = ""
    @State private var isShowingCreateAccountView = false
    
    @FocusState private var focused: FocusedField?
    
    let columnWidth: CGFloat = 300
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            KeyboardAvoiding(with: avoider) {
                Image("yellow_logo_no_bg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: columnWidth * 0.8)
                Spacer()
                emailInput
                passwordInput
                    .overlay(alignment: .trailing) {
                        if !editingPassword {
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
                        }
                    }
                finishButton
            }
            Group {
                HStack {
                    Spacer()
                    Button {
                        UserHandling.resetPassword(for: email) { error in
                            if let error = error {
                                alertTitle = "Could not send new password."
                                alertMessage = error.localizedErrorDescription ?? "Unknown error."
                                isShowingAlert = true
                            }
                        }
                    } label: {
                        Text("Forgot password?")
                    }
                }
                .frame(width: columnWidth)
                Divider()
                    .frame(width: columnWidth)
                    .padding()
                Button {
                    isShowingCreateAccountView = true
                } label: {
                    Text("Create new account")
                        .font(.caption)
                }
                .sheet(isPresented: $isShowingCreateAccountView) {
                    CreateAccountView()
                        .clearModalBackground()
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(
            ZStack {
                Image("backgroundbar")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                BackgroundBlob()
                    .fill(.black)
                    .blur(radius: 80)
                    .ignoresSafeArea()
            })
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
                    .textCase(.uppercase)
                    .font(.caption2)
                    .foregroundColor(.white)
                    .opacity(0.5)
                    .offset(y: -10)
            }
            
        }
        .frame(width: columnWidth, height: 24)
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
                ZStack {
                    SecureField("", text: $password, onCommit: {
                        withAnimation {
                            editingPassword = false
                        }
                    })
                    .font(.title3)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(.password)
                    .focused($focused, equals: .secure)
                    .onChange(of: focused, perform: { focus in
                        if focus == .secure {
                            avoider.editingField = 13
                            editingPassword = true
                        } else {
                            editingPassword = false
                        }
                    })
                    .opacity(showingPassword ? 0 : 1)
                    
                    TextField("", text: $password, onCommit: {
                        withAnimation {
                            editingPassword = false
                        }
                    })
                    .font(.title3)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(.password)
                    .focused($focused, equals: .password)
                    .onChange(of: focused, perform: { focus in
                        if focus == .password {
                            avoider.editingField = 13
                            editingPassword = true
                        } else {
                            editingPassword = false
                        }
                    })
                    .opacity(showingPassword ? 1 : 0)
                }

                
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
                    .textCase(.uppercase)
                    .font(.caption2)
                    .opacity(0.5)
                    .offset(y: -10)
            }
        }
        .frame(width: columnWidth, height: 24)
        .padding()
        .foregroundColor(.white)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(6)
        .addBorder(editingPassword ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
        .avoidKeyboard(tag: 13)
        
    }
    
    private var finishButton: some View {
        Color.clear
            .frame(width: columnWidth, height: 16)
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
                        UserHandling.signIn(withEmail: email, password: password) { error in
                            if let error = error {
                                alertTitle = "Could not sign in."
                                alertMessage = error.localizedErrorDescription ?? "Unknown error."
                                isShowingAlert = true
                            }
                        }
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.accentColor)
                        .overlay {
                            Text("Sign in")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .textCase(.uppercase)
                        }
                }
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK").foregroundColor(.accentColor)))
            }
    }
    
    private func isPhone() -> Bool {
        return !(horizontalSizeClass == .regular && verticalSizeClass == .regular)
    }
    
    enum FocusedField {
        case username
        case password
        case secure
    }
}
