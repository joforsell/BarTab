//
//  ContentView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userHandler: UserHandling
    @StateObject var avoider = KeyboardAvoider()
    
    var body: some View {
        if userHandler.userAuthState == .signedIn {
            HomeView()
                .environmentObject(avoider)
        } else {
            PaywallView()
        }
    }
}


