//
//  DrinkViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-18.
//

import Foundation
import Combine

class DrinkViewModel: ObservableObject, Identifiable {
    @Published var drinkRepository = DrinkRepository()
    @Published var drink: Drink
    @Published var priceAsString = ""
    @Published var name = ""

    
    var id = ""
        
    private var cancellables = Set<AnyCancellable>()
    
    init(drink: Drink) {
        self.drink = drink
        
        $drink
            .compactMap { drink in
                drink.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        
        $drink
            .compactMap { drink in
                drink.name
            }
            .assign(to: \.name, on: self)
            .store(in: &cancellables)

        
        $drink
            .map { drink in
                String(drink.price)
            }
            .assign(to: \.priceAsString, on: self)
            .store(in: &cancellables)
                
        $name
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { name in
                self.drinkRepository.updateDrinkName(of: self.drink, to: name)
            }
            .store(in: &cancellables)

        $priceAsString
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { price in
                self.drinkRepository.updateDrinkPrice(of: self.drink, to: Int(price) ?? 0)
            }
            .store(in: &cancellables)
    }
}
