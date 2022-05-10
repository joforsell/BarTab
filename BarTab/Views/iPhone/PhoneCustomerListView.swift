//
//  PhoneCustomerListView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-02-26.
//

import SwiftUI

struct PhoneCustomerListView: View {
    
    @AppStorage("backgroundColorIntensity") var backgroundColorIntensity: ColorIntensity = .medium
    
    var body: some View {
        CustomerListView()
            .background(
                Image("backgroundbar")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(backgroundColorIntensity.overlayColor)
                    .ignoresSafeArea()
            )
    }
}
