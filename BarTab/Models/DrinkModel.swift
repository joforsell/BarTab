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
    var price: Int
    var userId: String?
}
