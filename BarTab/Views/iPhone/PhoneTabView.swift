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
    @StateObject var userHandler = UserHandling()
    @StateObject var drinkListVM = DrinkListViewModel()
    @StateObject var customerListVM = CustomerListViewModel()
    
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
        .onAppear {
            drinkListVM.setup(userHandler.user.showingDecimals)
        }
    }
}
