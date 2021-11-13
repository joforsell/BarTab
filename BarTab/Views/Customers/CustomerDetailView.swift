//
//  CustomerDetailView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-17.
//

import SwiftUI

struct CustomerDetailView: View {
    var customer: Customer
    var uniqueDrinks: [String] {
        var drinks: [String] = []
        for drink in customer.drinksBought {
            if !drinks.contains(drink.name) {
                drinks.append(drink.name)
            }
        }
        return drinks
    }
    
    var body: some View {
        List {
            Section {
                ForEach(uniqueDrinks, id: \.self) { drink in
                    Text("\(drink): \(addDrinksWithSameName(drinkArray: customer.drinksBought, selectedDrink: drink))")
                }
            } header: {
                Text("Köpta drycker")
            }
        }
    }
    
    func addDrinksWithSameName(drinkArray: [Drink], selectedDrink: String) -> Int {
        var sumOfDrinks = 0
        for drink in drinkArray {
            if drink.name == selectedDrink {
                sumOfDrinks += 1
            }
        }
        return sumOfDrinks
    }
}






struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerDetailView(customer: Customer(name: "Johan", balance: 500, key: "TETEEE", email: "k.g@y.com"))
    }
}
