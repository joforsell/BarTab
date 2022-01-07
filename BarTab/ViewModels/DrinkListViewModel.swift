//
//  DrinkViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI
import Combine

class DrinkListViewModel: ObservableObject {
    @Published var drinkRepository = DrinkRepository()
    @Published var drinkVMs = [DrinkViewModel]()
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        drinkRepository.$drinks
            .map { drinks in
                drinks.map { drink in
                    DrinkViewModel(drink: drink)
                }
            }
            .assign(to: \.drinkVMs, on: self)
            .store(in: &subscriptions)
    }
                    
    func addDrink(name: String, price: Int) {
        let newDrink = Drink(name: name, price: price)
        drinkRepository.addDrink(newDrink)
    }
    
    func removeDrink(_ id: String) {
        guard let index = drinkRepository.drinks.firstIndex(where: { $0.id == id }) else { return }
            let drink = drinkRepository.drinks[index]
            drinkRepository.removeDrink(drink)
    }
    
    func findDrinkVMByDrinkName(_ name: String) -> DrinkViewModel {
        let index = drinkVMs.firstIndex(where: { $0.drink.name == name })
        return drinkVMs[index!]
    }
}
