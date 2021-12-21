//
//  BarTabApp.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI
import Firebase

@main
struct BarTabApp: App {
    @StateObject var userHandler = UserHandling()
    @StateObject var customerListVM = CustomerListViewModel()
    @StateObject var drinkListVM = DrinkListViewModel()
    @StateObject var confirmationVM = ConfirmationViewModel()
    
    init() {
        FirebaseApp.configure()
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userHandler)
                .environmentObject(customerListVM)
                .environmentObject(drinkListVM)
                .environmentObject(confirmationVM)
        }
    }
}

