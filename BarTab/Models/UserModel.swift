//
//  UserModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-09.
//

import Foundation

struct User: Codable {
    var email: String?
    var association: String?
    var number: String?
    var usingTags: Bool = false
    var drinkCardColumns: Int = 4
    var drinkSorting: DrinkListViewModel.DrinkSorting = .az
    var currency: Currency = .usd
    var showingDecimals: Bool = true
    var isUpdated: Bool? = false
}
