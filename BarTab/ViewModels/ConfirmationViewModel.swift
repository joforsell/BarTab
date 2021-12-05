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
    
    init() {
        self.isShowingConfirmationView = false
    }
}
