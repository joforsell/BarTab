//
//  DrinkModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Drink: Codable, Identifiable {
    @DocumentID var id = UUID().uuidString
    var name: String
    var price: Float
    var userId: String?
    var image: DrinkImage = .beer
}

enum DrinkImage: String, Codable, CaseIterable {
    case beer
    case gintonic
    case shot
    case whiskey
    case cocktail
    case coffee
    case drink
    case fruitjuice
    case glasswithstraw
    case tea
    case wine
    case beermug
    case cocktail2
    case coconutdrink
    case colddrink
    case energydrink
    case firecocktail
    case glass
    case hotchocolate
    case martini
    case smoothie
    case teacup
}
