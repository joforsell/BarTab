//
//  BarTabApp.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI
import Firebase
import Purchases

@main
struct BarTabApp: App {
    @StateObject var authentication = Authentication()
    @StateObject var confirmationVM = ConfirmationViewModel()
    @StateObject var settingsStateContainer = SettingsStateContainer()
        
    init() {
        FirebaseApp.configure()
        
        Purchases.configure(withAPIKey: Keys.revenueCat)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authentication)
                .environmentObject(confirmationVM)
                .environmentObject(settingsStateContainer)
                .environmentObject(settingsStateContainer.settingsState)
                .environmentObject(settingsStateContainer.detailViewState)
                .preferredColorScheme(.dark)
        }
    }
}

