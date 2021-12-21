//
//  ContentView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userHandler: UserHandling
    
    var body: some View {
        if userHandler.userAuthState == .signedIn {
            HomeView()
        } else if userHandler.userAuthState == .signedOut {
            LoginView()
        } else {
            PaywallView()
        }
    }
}


