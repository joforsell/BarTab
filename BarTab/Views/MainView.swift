//
//  MainView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var drinkStore: DrinkStore
    
    var body: some View {
        TabView {
            InputView()
                .environmentObject(userStore)
                .environmentObject(drinkStore)
                .tabItem { Label("Beställ", systemImage: "plus.circle.fill") }
            UserListView()
                .environmentObject(userStore)
                .tabItem { Label("Medlemmar", systemImage: "person.2.fill") }
            SettingsView()
                .environmentObject(userStore)
                .environmentObject(drinkStore)
                .tabItem { Label("Inställningar", systemImage: "gearshape.fill") }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            MainView()
                .environmentObject(UserStore())
                .environmentObject(DrinkStore())
                .previewInterfaceOrientation(.landscapeRight)
        } else {
            MainView()
        }
    }
}
