//
//  DrinkViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI

class DrinkViewModel: ObservableObject {
    @Published var drinks = [Drink]()
    
    init(){}
    
    var defaultDrinks = [Drink(name: "Finöl", price: 40), Drink(name: "Fulöl", price: 20), Drink(name: "Gin & Tonic", price: 50), Drink(name: "Snaps", price: 30), Drink(name: "Rött vin", price: 40), ,Drink(name: "Vitt vin", price: 40), Drink(name: "Cider", price: 60), Drink(name: "Shot", price: 30), Drink(name: "Kaffe Karlsson", price: 80)]
                
    func addDrink(name: String, price: Int) {
        let newDrink = Drink(name: name, price: price)
        drinks.append(newDrink)
    }
    
    func removeDrinkBy(id: String) {
        drinks.removeAll(where: { $0.id == id })
    }
    
    func adjustPriceOfDrinkTo(_ newPrice: Int, id: String) {
        if let index = drinks.firstIndex(where: { $0.id == id }) {
            drinks[index].price = newPrice
        } else {
            return
        }
    }
}
