//
//  PhoneCustomerListView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-02-26.
//

import SwiftUI

struct PhoneCustomerListView: View {
    var body: some View {
        Text("CustomerList")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("backgroundbar")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(Color.black.opacity(0.5).blendMode(.overlay))
                    .ignoresSafeArea()
            )

    }
}
