//
//  ContentView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authentication: Authentication
    @StateObject var avoider = KeyboardAvoider()
    
    var body: some View {
        switch authentication.userAuthState {
        case .signedOut:
            SignInView()
                .environmentObject(avoider)
        case .signedIn:
            PaywallView()
                .environmentObject(avoider)
        case .subscribed:
            HomeView()
                .environmentObject(avoider)
        }
    }
}

