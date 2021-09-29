//
//  UserModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import Foundation

struct User: Codable, Identifiable {
    var id = UUID().uuidString
    var name: String
    var balance: Int
    var key: String
    var drinksBought: [Drink]
}
