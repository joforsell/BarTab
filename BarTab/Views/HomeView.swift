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
    
    var body: some View {
        TabView {
            InputView()
                .tabItem { Label("Beställ", systemImage: "plus.circle.fill") }
            UserListView()
                .tabItem { Label("Medlemmar", systemImage: "person.2.fill") }
            SettingsView()
                .tabItem { Label("Inställningar", systemImage: "gearshape.fill") }
        }
        .onAppear {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            UserHandling.retrieveUser(uid: uid) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let user):
                    self.userInfo.user = user
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
                .previewInterfaceOrientation(.landscapeRight)
        } else {
            HomeView()
        }
    }
}
