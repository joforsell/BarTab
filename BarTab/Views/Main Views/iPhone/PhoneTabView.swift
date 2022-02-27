//
//  PhoneTabView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-02-26.
//

import SwiftUI
import SwiftUIX

struct PhoneTabView: View {
    var body: some View {
        TabView {
            PhoneOrderView()
                .tabItem {
                    Image(systemName: "house")
                }
            PhoneCustomerListView()
                .tabItem {
                    Image(systemName: "person")
                }
            PhoneSettingsView()
                .tabItem {
                    Image(systemName: "gear")
                }
        }
    }
}

struct PhoneTabView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneTabView()
    }
}
