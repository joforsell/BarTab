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
    
    @StateObject var vm = SignInViewModel()
    
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
                        if !vm.editingPassword {
                            Button {
                                vm.showingPassword.toggle()
                            } label: {
                                Image(systemName: vm.showingPassword ? "eye.fill" : "eye.slash.fill")
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
                        vm.handleResetPassword()
                    } label: {
                        Text("Forgot password?")
                    }
                }
                .frame(width: columnWidth)
                Divider()
                    .frame(width: columnWidth)
                    .padding()
                Button {
                    vm.isShowingCreateAccountView = true
                } label: {
                    Text("Create new account")
                        .font(.caption)
                }
                .sheet(isPresented: $vm.isShowingCreateAccountView) {
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
                          text: $vm.email,
                          onEditingChanged: { editingChanged in
                    self.avoider.editingField = 12
                    if editingChanged {
                        withAnimation {
                            vm.editingEmail = true
                        }
                    } else {
                        withAnimation {
                            vm.editingEmail = false
                        }
                    } },
                          onCommit: {
                    withAnimation {
                        vm.editingEmail.toggle()
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
                    Image(systemName: vm.editingEmail ? "checkmark.rectangle.fill" : "person.crop.square.filled.and.at.rectangle.fill")
                        .resizable()
                        .scaledToFit()
                        .opacity(vm.editingEmail ? 1 : 0.5)
                        .foregroundColor(vm.editingEmail ? .accentColor : .white)
                }
                .disabled(!vm.editingEmail)
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
        .addBorder(vm.editingEmail ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
        .avoidKeyboard(tag: 12)
        
    }
    
    private var passwordInput: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .bottom) {
                ZStack {
                    SecureField("", text: $vm.password, onCommit: {
                        withAnimation {
                            vm.editingPassword = false
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
                            vm.editingPassword = true
                        } else {
                            vm.editingPassword = false
                        }
                    })
                    .opacity(vm.showingPassword ? 0 : 1)
                    
                    TextField("", text: $vm.password, onCommit: {
                        withAnimation {
                            vm.editingPassword = false
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
                            vm.editingPassword = true
                        } else {
                            vm.editingPassword = false
                        }
                    })
                    .opacity(vm.showingPassword ? 1 : 0)
                }

                
                Spacer()
            }
            .offset(y: 4)
            .overlay(alignment: .trailing) {
                if vm.editingPassword {
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
        .addBorder(vm.editingPassword ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
        .avoidKeyboard(tag: 13)
        
    }
    
    private var finishButton: some View {
        Color.clear
            .frame(width: columnWidth, height: 16)
            .padding()
            .overlay {
                Button {
                    vm.handleSignInButton()
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
            .alert(isPresented: $vm.isShowingAlert) {
                Alert(title: Text(vm.alertTitle), message: Text(vm.alertMessage), dismissButton: .default(Text("OK").foregroundColor(.accentColor)))
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
