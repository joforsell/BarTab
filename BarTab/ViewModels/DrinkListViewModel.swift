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
    @Published var userHandler = UserHandling()
    
    @Published var sorting: DrinkListViewModel.DrinkSorting = .az
        
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        userHandler.$user
            .map {
                $0.drinkSorting
            }
            .assign(to: \.sorting, on: self)
            .store(in: &subscriptions)
        
        drinkRepository.$drinks
            .map { drinks in
                let sortedDrinks = drinks.sorted { $0.name < $1.name}
                return sortedDrinks.map { drink in
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
    
    func removeDrink(_ drink: Drink) {
        guard drink.id != nil else { return }
        
        drinkRepository.removeDrink(drink)
    }
    
    func updateDrinkPrice(of drink: Drink, to price: Int) {
        guard drink.id != nil else { return }
        
        drinkRepository.updateDrinkPrice(of: drink, to: price)
    }
    
    func updateDrinkName(of drink: Drink, to name: String) {
        guard drink.id != nil else { return }
        
        drinkRepository.updateDrinkName(of: drink, to: name)
    }
    
    // MARK: - Sorting
    enum DrinkSorting: Int, Codable, CaseIterable {
        case highPriceFirst = 0, lowPriceFirst = 1, za = 2, az = 3
        
        init(type: Int) {
            switch type {
            case 0: self = .highPriceFirst
            case 1: self = .lowPriceFirst
            case 2: self = .za
            case 3: self = .az
            default: self = .az
            }
        }
        
        var description: String {
            switch self {
            case .az: return "A-Ö"
            case .za: return "Ö-A"
            case .lowPriceFirst: return "Lägst pris först"
            case .highPriceFirst: return "Högst pris först"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case az = "az"
            case za = "za"
            case lowPriceFirst = "low"
            case highPriceFirst = "high"
        }
    }
    
    func sortDrinks(_ drinkVMs: [DrinkViewModel], by sorting: DrinkListViewModel.DrinkSorting) -> [DrinkViewModel] {
        var sortedDrinks = [DrinkViewModel]()
        switch sorting {
        case .az:
            sortedDrinks = drinkVMs.sorted { $0.drink.name < $1.drink.name }
        case .za:
            sortedDrinks = drinkVMs.sorted { $0.drink.name > $1.drink.name }
        case .lowPriceFirst:
            sortedDrinks = drinkVMs.sorted { $0.drink.price < $1.drink.price }
        case .highPriceFirst:
            sortedDrinks = drinkVMs.sorted { $0.drink.price > $1.drink.price }
        }
        return sortedDrinks
    }
}
