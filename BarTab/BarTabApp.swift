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
    @StateObject var userInfo = UserInfo()
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
            HomeView()
                .environmentObject(userInfo)
                .environmentObject(userHandler)
                .environmentObject(customerListVM)
                .environmentObject(drinkListVM)
                .environmentObject(confirmationVM)
        }
    }
}

