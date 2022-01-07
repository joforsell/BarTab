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
    @StateObject var userHandler = UserHandling()
    @StateObject var customerListVM = CustomerListViewModel()
    @StateObject var drinkListVM = DrinkListViewModel()
    @StateObject var confirmationVM = ConfirmationViewModel()
        
    init() {
        FirebaseApp.configure()
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously()
        }
        
        Purchases.configure(withAPIKey: "appl_mtWeWLbXBczlrxImSUOLQowDdlK", appUserID: Auth.auth().currentUser?.uid)
        Purchases.logLevel = .debug
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authentication)
                .environmentObject(userHandler)
                .environmentObject(customerListVM)
                .environmentObject(drinkListVM)
                .environmentObject(confirmationVM)
        }
    }
}

