//
//  DrinkViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI
import Combine

class DrinkViewModel: ObservableObject {
    @Published var drinkRepository = DrinkRepository()
    @Published var drinks = [Drink]()
    
    var subscriptions = Set<AnyCancellable>()
    
    init(){
        drinkRepository.$drinks
            .assign(to: \.drinks, on: self)
            .store(in: &subscriptions)
    }
                    
    func addDrink(name: String, price: Int) {
        let newDrink = Drink(name: name, price: price)
        drinkRepository.addDrink(newDrink)
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
