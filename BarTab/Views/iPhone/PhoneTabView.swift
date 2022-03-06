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
    
    @State private var selection: TabBarItem = .drinks

    var body: some View {
        CustomTabBarContainerView(selection: $selection) {
            PhoneOrderView()
                .tabBarItem(tab: .drinks, selection: $selection)
                .environmentObject(drinkListVM)
                .environmentObject(customerListVM)
                .environmentObject(userHandler)
            PhoneCustomerListView()
                .tabBarItem(tab: .customers, selection: $selection)
                .environmentObject(customerListVM)
                .environmentObject(userHandler)
            PhoneSettingsView()
                .tabBarItem(tab: .settings, selection: $selection)
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
