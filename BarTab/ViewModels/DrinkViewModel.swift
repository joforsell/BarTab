//
//  DrinkViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-18.
//

import Foundation
import Combine
import SwiftUI

class DrinkViewModel: ObservableObject, Identifiable {
    @Published var drinkRepository = DrinkRepository()
    @Published var drink: Drink
    @Published var priceAsString = ""
    @Published var name = ""
    @Published var image: DrinkImage = .beer
    @Published var showingDecimals: Bool
            
    var id = ""
        
    private var cancellables = Set<AnyCancellable>()
    
    init(showingDecimals: Bool, drink: Drink) {
        self.showingDecimals = showingDecimals
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
                let drinkPrice = Float(drink.price) / 100
                if self.showingDecimals {
                    print("showingDecimals is true")
                    return String(format: "%.2f", drinkPrice)
                } else {
                    print("showingDecimals is false")
                    return String(format: "%.0f", drinkPrice)
                }
            }
            .assign(to: \.priceAsString, on: self)
            .store(in: &cancellables)
        
//        $showingDecimals
//            .map { showingDecimals in
//                if showingDecimals {
//                    return String(format: "%.2f", (self.drink.price))
//                } else {
//                    return String(format: "%.0f", (self.drink.price))
//                }
//            }
//            .assign(to: \.priceAsString, on: self)
//            .store(in: &cancellables)
        
        $drink
            .map { drink in
                drink.image
            }
            .assign(to: \.image, on: self)
            .store(in: &cancellables)
                
        $name
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { name in
                self.drinkRepository.updateDrinkName(of: self.drink, to: name)
            }
            .store(in: &cancellables)
        
        $image
            .sink { image in
                self.drinkRepository.updateImage(of: self.drink, to: image.rawValue)
            }
            .store(in: &cancellables)
    }
}
