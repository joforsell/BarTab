//
//  UserSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-01-18.
//

import SwiftUI
import Purchases
import Firebase

struct UserSettingsView: View {
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
                .frame(height: 120)
                .foregroundColor(.accentColor)
                .padding(.bottom, 48)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Kopplad mailadress:")
                    Spacer()
                    Text(Auth.auth().currentUser?.email ?? "-")
                }
                Divider()
                HStack {
                    Text("Användaren skapades:")
                    Spacer()
                    Text(userSettingsVM.firstSeenAsString)
                }
                Divider()
                    .frame(width: 300)
                HStack {
                    Text("Prenumerationen förnyas:")
                    Spacer()
                    Text(userSettingsVM.expireDateAsString)
                }
                Divider()
                    .frame(width: 300)
                HStack {
                    Text("Typ av prenumeration:")
                    Spacer()
                    Text(userSettingsVM.purchaser?.activeSubscriptions.first ?? "Livstid")
                }
                Divider()
                    .padding(.bottom, 48)
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
                        userHandler.signOut { completed in
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
                }
            }
            .foregroundColor(.white)
            .frame(width: 500)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .center(.horizontal)
        .overlay(alignment: .topTrailing) {
            Button {
                withAnimation {
                    settingsShown = .bartender
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
}
