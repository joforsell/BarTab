//
//  ConfirmationViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-05.
//

import Foundation

class ConfirmationViewModel: ObservableObject {
    @Published var isShowingConfirmationView: Bool
    @Published var selectedDrink: DrinkViewModel?
    
    static let errorDrink = DrinkViewModel(drink: Drink(name: "Dryck saknas", price: 0))
    
    init() {
        self.isShowingConfirmationView = false
    }
}
