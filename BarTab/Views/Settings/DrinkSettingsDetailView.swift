//
//  DrinkSettingsDetailView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-15.
//

import SwiftUI

struct DrinkSettingsDetailView: View {
    @Binding var drink: Drink
    
    var body: some View {
        VStack(spacing: 20) {
            Text(drink.name)
            Text("\(drink.price)")
        }
    }
}
