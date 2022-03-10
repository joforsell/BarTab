//
//  TransactionModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-27.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Transaction: Codable, Identifiable {
    var id = UUID().uuidString
    var description: String
    var amount: Int
    var createdTime: Date
}
