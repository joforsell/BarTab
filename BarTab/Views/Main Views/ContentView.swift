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
        if authentication.userAuthState == .signedIn {
            HomeView()
                .environmentObject(avoider)
        } else {
            PaywallView()
        }
    }
}


