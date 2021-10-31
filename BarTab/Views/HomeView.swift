//
//  HomeView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @EnvironmentObject var userInfo: UserInfo
    @StateObject var customerVM = CustomerViewModel()
    @StateObject var drinkVM = DrinkViewModel()
    @StateObject var settings = UserSettingsViewModel()
    
    var body: some View {
        TabView {
            InputView()
                .environmentObject(customerVM)
                .environmentObject(drinkVM)
                .environmentObject(settings)
                .tabItem { Label("Beställ", systemImage: "plus.circle.fill") }
            CustomerListView()
                .environmentObject(customerVM)
                .environmentObject(drinkVM)
                .environmentObject(settings)
                .tabItem { Label("Medlemmar", systemImage: "person.2.fill") }
            SettingsView()
                .environmentObject(customerVM)
                .environmentObject(drinkVM)
                .environmentObject(settings)
                .tabItem { Label("Inställningar", systemImage: "gearshape.fill") }
        }
        .accentColor(Color("AppYellow"))
        .onAppear {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            UserHandling.retrieveUser(uid: uid) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let user):
                    userInfo.user = user
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            HomeView()
                .environmentObject(CustomerViewModel())
                .environmentObject(DrinkViewModel())
                .environmentObject(UserSettingsViewModel())
                .previewInterfaceOrientation(.landscapeRight)
        } else {
            HomeView()
        }
    }
}
