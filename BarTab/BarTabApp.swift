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
    @StateObject var settings = SettingsManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(userInfo)
                .environmentObject(settings)
        }
    }
}
