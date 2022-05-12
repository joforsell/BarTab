//
//  OrderViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-12.
//

import Foundation

class OrderViewModel: ObservableObject, Identifiable {
    let id: UUID
    @Published var drink: Drink
    
    init(id: UUID = UUID(), _ drink: Drink) {
        self.id = id
        self.drink = drink
    }
}
