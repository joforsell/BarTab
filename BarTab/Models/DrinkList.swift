//
//  DrinkList.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import Foundation

struct DrinkList: Codable {
    var drinkList: [Drink]
    
    var uniqueDrinkId = 0
    
    mutating func addDrink(name: String, price: Int) {
        uniqueDrinkId += 1
        let newDrink = Drink(id: uniqueDrinkId, name: name, price: price)
        drinkList.append(newDrink)
    }
    
    mutating func removeDrinkBy(id: Int) {
        drinkList.removeAll(where: { $0.id == id })
    }
    
    mutating func adjustPriceOfDrinkTo(_ newPrice: Int, id: Int) {
        if let index = drinkList.firstIndex(where: { $0.id == id }) {
            drinkList[index].price = newPrice
        } else {
            return
        }
    }
}

struct Drink: Codable, Identifiable {
    var id: Int
    var name: String
    var price: Int
}
