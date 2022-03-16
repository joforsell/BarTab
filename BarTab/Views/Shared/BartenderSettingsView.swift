//
//  UserSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI
import FirebaseAuth
import ToastUI

struct BartenderSettingsView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @EnvironmentObject var userHandler: UserHandling
    @EnvironmentObject var avoider: KeyboardAvoider
    @EnvironmentObject var customerListVM: CustomerListViewModel
    
    @Binding var settingsShown: SettingsRouter
    
    @AppStorage("latestEmail") var latestEmail: Date = Date(timeIntervalSinceReferenceDate: 60000)
    
    @State private var editingAssociation = false
    @State private var editingEmail = false
    @State private var editingPhoneNumber = false
    
    @State private var showError = false
    @State private var errorString: LocalizedStringKey = ""
    @State private var errorTitle: LocalizedStringKey = ""
    @State private var localizedErrorString = ""
    @State private var showLocalizedError = false
    
    @State private var showingUserInformation = false
    @State private var isShowingEmailConfirmation = false
    @State private var confirmEmails = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            
            Image("bartender")
                .resizable()
                .scaledToFit()
                .frame(width: isPhone() ? UIScreen.main.bounds.width/2 : 200)
                .foregroundColor(.accentColor)
                .offset(x: -20)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .bottom) {
                    TextField("",
                              text: $userHandler.user.email,
                              onEditingChanged: { editingChanged in
                        self.avoider.editingField = 1
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
                        userHandler.updateUserEmail(userHandler.user.email ?? "")
                    }
                    )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .font(.title3)
                    Spacer()
                }
                .offset(y: 4)
                .overlay(alignment: .trailing) {
                    Image(systemName: editingEmail ? "checkmark.rectangle.fill" : "envelope.fill")
                        .resizable()
                        .scaledToFit()
                        .opacity(editingEmail ? 1 : 0.5)
                        .foregroundColor(editingEmail ? .accentColor : .white)
                        .onTapGesture {
                            editingEmail ? userHandler.updateUserEmail(userHandler.user.email ?? "") : nil
                            UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                }
                .overlay(alignment: .topLeading) {
                    Text("E-mail")
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
            .padding(.top, 48)
            .avoidKeyboard(tag: 1)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .bottom) {
                    TextField("",
                              text: $userHandler.user.association,
                              onEditingChanged: { editingChanged in
                        self.avoider.editingField = 2
                        if editingChanged {
                            withAnimation {
                                editingAssociation = true
                            }
                        } else {
                            withAnimation {
                                editingAssociation = false
                            }
                        } },
                              onCommit: {
                        withAnimation {
                            editingAssociation.toggle()
                        }
                        userHandler.updateUserAssociation(userHandler.user.association ?? "")
                    }
                    )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .font(.title3)
                    Spacer()
                }
                .offset(y: 4)
                .overlay(alignment: .trailing) {
                    Image(systemName: editingAssociation ? "checkmark.rectangle.fill" : "suitcase.fill")
                        .resizable()
                        .scaledToFit()
                        .opacity(editingAssociation ? 1 : 0.5)
                        .foregroundColor(editingAssociation ? .accentColor : .white)
                        .onTapGesture {
                            editingAssociation ? userHandler.updateUserAssociation(userHandler.user.association ?? "") : nil
                            UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    
                }
                .overlay(alignment: .topLeading) {
                    Text("Association")
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
            .addBorder(editingAssociation ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
            .avoidKeyboard(tag: 2)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .bottom) {
                    TextField("",
                              text: $userHandler.user.number,
                              onEditingChanged: { editingChanged in
                        self.avoider.editingField = 3
                        if editingChanged {
                            withAnimation {
                                editingPhoneNumber = true
                            }
                        } else {
                            withAnimation {
                                editingPhoneNumber = false
                            }
                        } },
                              onCommit: {
                        withAnimation {
                            editingPhoneNumber.toggle()
                        }
                        userHandler.updateUserPhoneNumber(userHandler.user.number ?? "")
                    }
                    )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .font(.title3)
                    Spacer()
                }
                .offset(y: 4)
                .overlay(alignment: .trailing) {
                    Image(systemName: editingPhoneNumber ? "checkmark.rectangle.fill" : "phone.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .opacity(editingPhoneNumber ? 1 : 0.5)
                        .foregroundColor(editingPhoneNumber ? .accentColor : .white)
                        .onTapGesture {
                            editingPhoneNumber ? userHandler.updateUserPhoneNumber(userHandler.user.number ?? "") : nil
                            UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    
                }
                .overlay(alignment: .topLeading) {
                    Text("Phone number")
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
            .addBorder(editingPhoneNumber ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
            .avoidKeyboard(tag: 3)
            
            HStack {
                Text("Currency")
                    .foregroundColor(.white)
                Spacer()
                Picker("Currency", selection: $userHandler.user.currency) {
                    Text("SEK").tag(Currency.sek)
                    Text("NOK").tag(Currency.nok)
                    Text("DKR").tag(Currency.dkr)
                    Text("USD").tag(Currency.usd)
                    Text("EUR").tag(Currency.eur)
                    Text("GBP").tag(Currency.gbp)
                }
            }
            .frame(width: 300, height: 24)
            
            Toggle("Use RFID tags", isOn: $userHandler.user.usingTags)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .frame(width: 300, height: 24)
                .foregroundColor(.white)
                .onChange(of: userHandler.user.usingTags) { usingTags in
                    userHandler.updateUserTagUsage(usingTags)
                }
            Spacer()
        }
        .sheet(isPresented: $showingUserInformation) {
            UserSettingsView(settingsShown: $settingsShown)
                .clearModalBackground()
        }
        .center(.horizontal)
        .overlay(alignment: .topTrailing) {
            VStack {
                Button {
                    withAnimation {
                        if isPhone() {
                            showingUserInformation = true
                        } else {
                            settingsShown = .user
                        }
                    }
                } label: {
                    VStack(alignment: .center) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44)
                    }
                    .padding()
                    .foregroundColor(.accentColor)
                }
                if isPhone() {
                    emailButton
                        .alert(isPresented: $showError) {
                            if oneDayHasElapsedSince(latestEmail) {
                                return Alert(title: Text(errorTitle),
                                             message: Text(errorString),
                                             primaryButton: .default(Text("Cancel")),
                                             secondaryButton: .default(Text("OK"), action: emailButtonAction))
                            } else {
                                return Alert(title: Text(errorTitle), message: Text(errorString), dismissButton: .default(Text("OK")))
                            }
                        }
                }
            }
            .toast(isPresented: $isShowingEmailConfirmation, dismissAfter: 6, onDismiss: { isShowingEmailConfirmation = false }) {
                ToastView(systemImage: ("envelope.fill", .accentColor, 50), title: "E-mail(s) sent", subTitle: "An e-mail showing current balance was sent to each bar guest with an associated e-mail address.")
            }
        }
    }
    
    private func isPhone() -> Bool {
        return !(horizontalSizeClass == .regular && verticalSizeClass == .regular)
    }
    
    private func oneDayHasElapsedSince(_ date: Date) -> Bool {
        let timeSinceLatestEmail = -latestEmail.timeIntervalSinceNow
        return timeSinceLatestEmail > 60
    }
    
    private var emailButton: some View {
        Button {
            if oneDayHasElapsedSince(latestEmail) {
                errorTitle = "Are you sure you want to send e-mail(s)?"
                errorString = "This will send an e-mail showing current balance to each bar guest with an associated e-mail address."
            } else {
                errorTitle = "Could not send"
                errorString = "You can only send e-mail(s) once every minute."
            }
            showError = true
        } label: {
            Image(systemName: "envelope.fill")
                .font(.largeTitle)
                .foregroundColor(oneDayHasElapsedSince(latestEmail) ? .accentColor : .accentColor.opacity(0.3))
        }
        .alert(isPresented: $showLocalizedError) {
            Alert(title: Text(errorTitle), message: Text(localizedErrorString), dismissButton: .default(Text("OK")))
        }
    }
    
    private func emailButtonAction() {
        var customers = [Customer]()
        customerListVM.customerVMs.forEach { customerVM in
            customers.append(customerVM.customer)
        }
        customerListVM.sendEmails(from: userHandler.user, to: customers) { result in
            switch result {
            case .failure(let error):
                errorTitle = "Error sending emails"
                localizedErrorString = error.localizedDescription
                showLocalizedError = true
            case .success(_):
                latestEmail = Date()
            }
        }
        latestEmail = Date()
        withAnimation {
            isShowingEmailConfirmation.toggle()
        }
    }

}


