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
import Inject

struct UserSettingsView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var userHandler: UserHandling
    @EnvironmentObject var authentication: Authentication
    @ObservedObject var userSettingsVM = UserSettingsViewModel()
    @ObservedObject private var iO = Inject.observer
    @Binding var settingsShown: SettingsRouter
    
    @State private var isShowingAccountLinkModal = false
    @State private var isShowingDeleteAlert = false
    @State private var isShowingStopSubAlert = false
    @State private var isShowingLogOutAlert = false
        
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 20) {
                Spacer()
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
                                    Label("Delete account", systemImage: "trash.fill")
                                        .foregroundColor(.white)
                                        .font(.caption)
                                }
                        }
                        .frame(width: 150, height: 44)
                        .padding()
                        .alert(isPresented: $isShowingDeleteAlert) {
                            Alert(title: Text("Are you sure you want to delete your account?"), message: Text("When you delete your account, all related data is also deleted. Your subscription is not automatically cancelled, this needs to be done in your settings."), primaryButton: .default(Text("Cancel")), secondaryButton: .destructive(Text("Delete account")) { userHandler.deleteUser { result in
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
                                    Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
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
                Spacer()
            }
            .center(.horizontal)
            }
        .background(VisualEffectBlurView(blurStyle: .dark))
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
        .enableInjection()
    }
    
    @ViewBuilder
    private var phoneView: some View {
        VStack(alignment: .center) {
            Text("Connected e-mail address:").fontWeight(.bold)
            Text(Auth.auth().currentUser?.email ?? "-")
        }
        Divider()
            .frame(maxWidth: 300)
        VStack(alignment: .center) {
            Text("Subscription is renewed:").fontWeight(.bold)
            Text(userSettingsVM.expireDateAsString)
        }
        Divider()
            .frame(maxWidth: 300)
        VStack(alignment: .center) {
            Text("Subscription type:").fontWeight(.bold)
            if userSettingsVM.subscriptionType != "" {
                Text(userSettingsVM.subscriptionType)
            } else {
                Text("Lifetime")
            }
        }
        Divider()
            .frame(maxWidth: 300)
            .padding(.bottom, 48)
    }
    
    @ViewBuilder
    private var padView: some View {
        HStack {
            Text("Connected e-mail address:")
            Spacer()
            Text(Auth.auth().currentUser?.email ?? "-")
        }
        Divider()
            .frame(maxWidth: 300)
        HStack {
            Text("Subscription is renewed:")
            Spacer()
            Text(userSettingsVM.expireDateAsString)
        }
        Divider()
            .frame(maxWidth: 300)
        HStack {
            Text("Subscription type:")
            Spacer()
            Text(userSettingsVM.subscriptionType)
        }
        Divider()
            .frame(maxWidth: 300)
            .padding(.bottom, 48)
    }
    
    private func isPhone() -> Bool {
        return !(horizontalSizeClass == .regular && verticalSizeClass == .regular)
    }
}
