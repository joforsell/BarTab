//
//  Transaction.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-03-09.
//

import Foundation
import FirebaseFirestoreSwift

struct Transaction: Codable, Identifiable {
    @DocumentID var id = UUID().uuidString
    let name: String
    let image: String
    let amount: Int
    let date: Date
    let customerID: String
}

enum TransactionIcon: String, Codable, CaseIterable {
    case openingBalance
    case addedBalance
}
