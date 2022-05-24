//
//  DetailView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-24.
//

import Foundation

enum DetailView {
    case drink(drinkVM: DrinkViewModel)
    case customer(customerVM: CustomerViewModel)
    case none
}
