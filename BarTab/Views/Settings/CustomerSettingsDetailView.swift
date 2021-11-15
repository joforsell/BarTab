//
//  CustomerSettingsDetailView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-15.
//

import SwiftUI

struct CustomerSettingsDetailView: View {
    @Binding var customer: Customer
    
    var body: some View {
        VStack {
            Text(customer.name)
            Text("\(customer.balance)")
            ForEach(customer.drinksBought, id: \.id) { drink in
                Text(drink.name)
                Text("\(drink.price)")
            }
        }
    }
}
