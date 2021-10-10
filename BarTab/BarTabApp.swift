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
    @StateObject var customerVM = CustomerViewModel()
    @StateObject var drinkVM = DrinkViewModel()
    @StateObject var userInfo = UserInfo()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(customerVM)
                .environmentObject(drinkVM)
                .environmentObject(userInfo)
        }
    }
}
