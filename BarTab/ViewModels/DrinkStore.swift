//
//  ViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI

class DrinkStore: ObservableObject {
    @Published private var drinkList: DrinkList
    
    init(){
        drinkList = DrinkList(drinkList: [Drink(id: 0, name: "Finöl", price: 40), Drink(id: 1, name: "Fulöl", price: 20), Drink(id: 2, name: "Gin & Tonic", price: 50), Drink(id: 3, name: "Alkoholfri öl", price: 20), Drink(id: 4, name: "Rött vin", price: 40), Drink(id: 5, name: "Vitt vin", price: 40), Drink(id: 6, name: "Champagne", price: 45), Drink(id: 7, name: "Snaps", price: 30), Drink(id: 8, name: "Cider", price: 100), Drink(id: 9, name: "Shot", price: 30)])
    }
    
    var drinks: [Drink] {
        drinkList.drinkList
    }
    
    func addDrink(name: String, price: Int) {
        drinkList.addDrink(name: name, price: price)
    }
    
    func removeDrinkBy(id: Int) {
        drinkList.removeDrinkBy(id: id)
    }
    
    func adjustPriceOfDrinkTo(_ newPrice: Int, id: Int) {
        drinkList.adjustPriceOfDrinkTo(newPrice, id: id)
    }
}
