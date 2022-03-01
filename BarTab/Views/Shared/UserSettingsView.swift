//
//  UserSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-01-18.
//

import SwiftUI
import SwiftUIX
import Purchases
import Firebase

struct UserSettingsView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var userHandler: UserHandling
    @EnvironmentObject var authentication: Authentication
    @ObservedObject var userSettingsVM = UserSettingsViewModel()
    @Binding var settingsShown: SettingsRouter
    
    @State private var isShowingAccountLinkModal = false
    @State private var isShowingDeleteAlert = false
    @State private var isShowingStopSubAlert = false
    @State private var isShowingLogOutAlert = false
        
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 120)
                .foregroundColor(.accentColor)
                .padding(.bottom, isPhone() ? 24 : 48)
            
            VStack(alignment: isPhone() ? .center : .leading, spacing: 8) {
                if isPhone() {
                    phoneView
                } else {
                    padView
                }
                HStack {
                    Button {
                        isShowingDeleteAlert = true
                    } label: {
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(.red)
                            .overlay {
                                Label("Radera konto", systemImage: "trash.fill")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                    }
                    .frame(width: 150, height: 44)
                    .padding()
                    .alert(isPresented: $isShowingDeleteAlert) {
                        Alert(title: Text("Är du säker på att du vill radera ditt konto?"), message: Text("När du raderar ditt konto raderas också all relaterad data. Din prenumeration sägs inte upp automatiskt, detta måste du göra i dina inställningar."), primaryButton: .default(Text("Avbryt")), secondaryButton: .destructive(Text("Radera konto")) { userHandler.deleteUser { result in
                            switch result {
                            case .failure(let error):
                                print(error.localizedDescription)
                            case .success(_):
                                authentication.userAuthState = .signedOut
                            }
                        }
                        })
                    }
                    Spacer()
                    Button {
                        UserHandling.signOut { completed in
                            if completed {
                                authentication.userAuthState = .signedOut
                            }
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(.accentColor)
                            .overlay {
                                Label("Logga ut", systemImage: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                    }
                    .frame(width: 150, height: 44)
                    .padding()
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: isPhone() ? UIScreen.main.bounds.width : 500)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(VisualEffectBlurView(blurStyle: .dark))
        .center(.horizontal)
        .overlay(alignment: .topTrailing) {
            Button {
                withAnimation {
                    if isPhone() {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        settingsShown = .bartender
                    }
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var phoneView: some View {
        VStack(alignment: .center) {
            Text("Kopplad mailadress:").fontWeight(.bold)
            Text(Auth.auth().currentUser?.email ?? "-")
        }
        Divider()
            .frame(maxWidth: 300)
        VStack(alignment: .center) {
            Text("Användaren skapades:").fontWeight(.bold)
            Text(userSettingsVM.firstSeenAsString)
        }
        Divider()
            .frame(maxWidth: 300)
        VStack(alignment: .center) {
            Text("Prenumerationen förnyas:").fontWeight(.bold)
            Text(userSettingsVM.expireDateAsString)
        }
        Divider()
            .frame(maxWidth: 300)
        VStack(alignment: .center) {
            Text("Typ av prenumeration:").fontWeight(.bold)
            Text(userSettingsVM.purchaser?.activeSubscriptions.first ?? "Livstid")
        }
        Divider()
            .frame(maxWidth: 300)
            .padding(.bottom, 48)
    }
    
    @ViewBuilder
    private var padView: some View {
        HStack {
            Text("Kopplad mailadress:")
            Spacer()
            Text(Auth.auth().currentUser?.email ?? "-")
        }
        Divider()
            .frame(maxWidth: 300)
        HStack {
            Text("Användaren skapades:")
            Spacer()
            Text(userSettingsVM.firstSeenAsString)
        }
        Divider()
            .frame(maxWidth: 300)
        HStack {
            Text("Prenumerationen förnyas:")
            Spacer()
            Text(userSettingsVM.expireDateAsString)
        }
        Divider()
            .frame(maxWidth: 300)
        HStack {
            Text("Typ av prenumeration:")
            Spacer()
            Text(userSettingsVM.purchaser?.activeSubscriptions.first ?? "Livstid")
        }
        Divider()
            .frame(maxWidth: 300)
            .padding(.bottom, 48)
    }
    
    private func isPhone() -> Bool {
        return !(horizontalSizeClass == .regular && verticalSizeClass == .regular)
    }
}
