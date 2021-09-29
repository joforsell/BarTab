//
//  DrinkModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import Foundation

struct Drink: Codable, Identifiable {
    var id = UUID().uuidString
    var name: String
    var price: Int
}
