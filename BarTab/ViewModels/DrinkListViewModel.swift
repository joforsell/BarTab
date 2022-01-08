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
    
    func sortDrinks(_ drinks: [DrinkViewModel], by sorting: DrinkListViewModel.DrinkSorting) -> [DrinkViewModel] {
        if sorting != .none {
            var sortedDrinks = [DrinkViewModel]()
            switch sorting {
            case .az:
                sortedDrinks = drinks.sorted { $0.drink.name < $1.drink.name }
            case .za:
                sortedDrinks = drinks.sorted { $0.drink.name > $1.drink.name }
            case .lowPriceFirst:
                sortedDrinks = drinks.sorted { $0.drink.price < $1.drink.price }
            case .highPriceFirst:
                sortedDrinks = drinks.sorted { $0.drink.price > $1.drink.price }
            default:
                break
            }
            return sortedDrinks
        } else {
            return drinks
        }
    }
    
    enum DrinkSorting: Int, Codable, CaseIterable {
        case none = 0, az = 1, za = 2, lowPriceFirst = 3, highPriceFirst = 4
        
        init(type: Int) {
            switch type {
            case 0: self = .none
            case 1: self = .az
            case 2: self = .za
            case 3: self = .lowPriceFirst
            case 4: self = .highPriceFirst
            default: self = .none
            }
        }
        
        var description: String {
            switch self {
            case .none: return "Ingen sortering"
            case .az: return "A-Ö"
            case .za: return "Ö-A"
            case .lowPriceFirst: return "Lägst pris först"
            case .highPriceFirst: return "Högst pris först"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case none = "none"
            case az = "az"
            case za = "za"
            case lowPriceFirst = "low"
            case highPriceFirst = "high"
        }
    }
}
