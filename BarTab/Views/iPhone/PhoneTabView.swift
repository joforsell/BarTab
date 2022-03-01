//
//  PhoneTabView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-02-26.
//

import SwiftUI
import SwiftUIX

struct PhoneTabView: View {
    @EnvironmentObject var avoider: KeyboardAvoider
    @StateObject var drinkListVM = DrinkListViewModel()
    @StateObject var customerListVM = CustomerListViewModel()
    @StateObject var userHandler = UserHandling()

    var body: some View {
        TabView {
            PhoneOrderView()
                .tabItem {
                    Image(systemName: "house")
                }
                .environmentObject(drinkListVM)
                .environmentObject(customerListVM)
                .environmentObject(userHandler)
            PhoneCustomerListView()
                .tabItem {
                    Image(systemName: "person")
                }
                .environmentObject(customerListVM)
                .environmentObject(userHandler)
            PhoneSettingsView()
                .tabItem {
                    Image(systemName: "gear")
                }
                .environmentObject(drinkListVM)
                .environmentObject(customerListVM)
                .environmentObject(userHandler)
        }
    }
}

struct PhoneTabView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneTabView()
    }
}
