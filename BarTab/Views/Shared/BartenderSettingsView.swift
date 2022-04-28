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
    @EnvironmentObject var drinkListVM: DrinkListViewModel
    @AppStorage("keepAwake") var keepAwake = false
    
    @Binding var settingsShown: SettingsRouter
    
    @State private var editingAssociation = false
    @State private var editingEmail = false
    @State private var editingPhoneNumber = false
    
    @State private var localizedErrorString = ""
    @State private var showLocalizedError = false
    
    @State private var showingUserInformation = false
    @State private var confirmEmails = false
    @State private var presentingFeedbackSheet = false
    @State private var presentingEmailView = false
    @State private var showingPaymentMethodSelections = false
    
    @State private var editingSwish = false
    @State private var editingBankAccount = false
    @State private var editingPlusgiro = false
    @State private var editingVenmo = false
    @State private var editingPaypal = false
    @State private var editingCashApp = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                
                Image("bartender")
                    .resizable()
                    .scaledToFit()
                    .frame(width: isPhone() ? UIScreen.main.bounds.width/2 : 200)
                    .foregroundColor(.accentColor)
                    .offset(x: -20)
                
                // Settings fields and toggles
                Group {
                    emailInput
                    associationInput
                    phoneNumberInput
                    paymentMethodFields
                    currencyPicker
                    decimalsToggle
                    rfidToggle
                    stayAwakeToggle
                    feedbackButton
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
                    }
                }
            }
            .fullScreenCover(isPresented: $presentingEmailView) {
                BalanceUpdateEmailView(presenting: $presentingEmailView)
            }
        }
    }
    
    private var emailInput: some View {
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
    }
    
    private var associationInput: some View {
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
    }
    
    private var phoneNumberInput: some View {
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
    }
    
    private var paymentMethodFields: some View {
        VStack {
            HStack {
                Text("Payment methods")
                    .font(.caption)
                    .textCase(.uppercase)
                    .padding()
                Button {
                    showingPaymentMethodSelections.toggle()
                } label: {
                    Image(systemName: "chevron.down.square.fill")
                        .font(.caption)
                        .foregroundColor(.accentColor)
                }
                .popover(isPresented: $showingPaymentMethodSelections) {
                    MultiSelectionPickerView(items: $userHandler.paymentMethods)
                }
                Spacer()
            }
            ForEach(userHandler.paymentMethods.indices) { index in
                if userHandler.paymentMethods[index].active {
                    CustomInputView(title: makeLocalizedStringKey(for: userHandler.paymentMethods[index].method), image: "", editing: editingBool(for: userHandler.paymentMethods[index].method), text: $userHandler.paymentMethods[index].info, keyboardTag: 4 + index)
                }
            }
            .onChange(of: userHandler.paymentMethods) { _ in
                do {
                    try userHandler.updatePaymentMethods()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
    private func editingBool(for method: PaymentMethod) -> Binding<Bool> {
        switch method {
        case .swish:
            return $editingSwish
        case .bankAccount:
            return $editingBankAccount
        case .plusgiro:
            return $editingPlusgiro
        case .venmo:
            return $editingVenmo
        case .paypal:
            return $editingPaypal
        case .cashApp:
            return $editingCashApp
        }
    }
        
    private func makeLocalizedStringKey(for method: PaymentMethod) -> LocalizedStringKey {
        switch method {
        case .swish:
            return LocalizedStringKey("Swish")
        case .bankAccount:
            return LocalizedStringKey("Bank Account")
        case .plusgiro:
            return LocalizedStringKey("Plusgiro")
        case .venmo:
            return LocalizedStringKey("Venmo")
        case .paypal:
            return LocalizedStringKey("PayPal")
        case .cashApp:
            return LocalizedStringKey("Cash App")
        }
    }
    
    private var currencyPicker: some View {
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
            .onChange(of: userHandler.user.currency) { currency in
                userHandler.updateCurrency(currency)
            }
        }
        .frame(width: 300, height: 24)
    }
    
    private var decimalsToggle: some View {
        HStack {
            Text("Display decimals")
                .foregroundColor(.white)
            Spacer()
            Button {
                if userHandler.user.showingDecimals {
                    userHandler.updateDecimalUsage(false)
                    for drinkVM in drinkListVM.drinkVMs {
                        drinkVM.showingDecimals = false
                    }
                } else {
                    userHandler.updateDecimalUsage(true)
                    for drinkVM in drinkListVM.drinkVMs {
                        drinkVM.showingDecimals = true
                    }
                }
            } label: {
                if userHandler.user.showingDecimals {
                    Text("On")
                        .textCase(.uppercase)
                } else {
                    Text("Off")
                        .textCase(.uppercase)
                }
            }
            .foregroundColor(.accentColor)
        }
        .frame(width: 300, height: 24)
    }
    
    private var rfidToggle: some View {
        Toggle("Use RFID tags", isOn: $userHandler.user.usingTags)
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            .frame(width: 300, height: 24)
            .foregroundColor(.white)
            .onChange(of: userHandler.user.usingTags) { usingTags in
                userHandler.updateUserTagUsage(usingTags)
            }
    }
    
    private var stayAwakeToggle: some View {
        Toggle("Keep device awake", isOn: $keepAwake)
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            .frame(width: 300, height: 24)
            .foregroundColor(.white)
    }
    
    private var feedbackButton: some View {
        VStack {
            Text("Having issues or missing a feature?")
                .font(.caption2)
                .lineLimit(1)
                .minimumScaleFactor(0.3)
            Button {
                presentingFeedbackSheet = true
            } label: {
                RoundedRectangle(cornerRadius: 6)
                    .overlay {
                        Text("Let me know")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)
                    }
            }
            .sheet(isPresented: $presentingFeedbackSheet) {
                FeedbackMailView()
                    .clearModalBackground()
            }
        }
        .frame(width: 300, height: 48)
        .padding(.top, 48)
    }
    
    private func isPhone() -> Bool {
        return !(horizontalSizeClass == .regular && verticalSizeClass == .regular)
    }
        
    private var emailButton: some View {
        Button {
            withAnimation {
                presentingEmailView = true
            }
        } label: {
            Image(systemName: "envelope.fill")
                .font(.largeTitle)
                .foregroundColor(.accentColor)
        }
    }
}


