//
//  BarTabApp.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI

@main
struct BarTabApp: App {
    @StateObject var userStore = UserViewModel()
    @StateObject var drinkStore = DrinkViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(userStore)
                .environmentObject(drinkStore)
        }
    }
}
