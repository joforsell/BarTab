//
//  UserSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-09.
//

import SwiftUI

struct UserSettingsView: View {
    @EnvironmentObject var userInfo: UserInfo
    
    var body: some View {
        NavigationView {
            Button("Logga ut") {
                Authentication.logout { result in
                    print("Loggades ut")
                }
            }
            .navigationTitle("Inloggad som \(userInfo.user.displayName)")
        }
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView()
    }
}
