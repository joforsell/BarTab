//
//  SettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var drinkViewModel: DrinkViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: DrinkSettingsView().environmentObject(drinkViewModel)) {
                    Text("Drycker")
                }
                NavigationLink(destination: UserSettingsView().environmentObject(userViewModel)) {
                    Text("Medlemmar")
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
