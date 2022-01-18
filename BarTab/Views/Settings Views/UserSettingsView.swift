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
    @ObservedObject var userSettingsVM = UserSettingsViewModel()
    @Binding var settingsShown: SettingsRouter
        
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
                    Text("Användaren skapades:")
                    Spacer()
                    Text(userSettingsVM.firstSeenAsString)
                }
                Divider()
                    .frame(width: 300)
                HStack {
                    Text("Automatisk förnyelse av prenumeration:")
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
