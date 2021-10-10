//
//  SettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI

struct SettingsView: View {

    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: DrinkSettingsView()) {
                    Text("Drycker")
                }
                NavigationLink(destination: CustomerSettingsView()) {
                    Text("Medlemmar")
                }
                NavigationLink(destination: UserSettingsView()) {
                    Text("Användare")
                }
            }
            .navigationTitle("Inställningar")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            SettingsView()
                .previewInterfaceOrientation(.landscapeRight)
            DrinkSettingsView()
                .previewInterfaceOrientation(.landscapeRight)
        } else {
            SettingsView()
        }
    }
}
