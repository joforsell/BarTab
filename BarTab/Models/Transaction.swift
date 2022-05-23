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
    let newBalance: Int
    let date: Date
    let customerID: String
    let transactionNumber: Int?
    let note: String?
    
    init(name: String, image: String, amount: Int, newBalance: Int, date: Date, customerID: String, transactionNumber: Int?, note: String? = nil) {
        self.name = name
        self.image = image
        self.amount = amount
        self.newBalance = newBalance
        self.date = date
        self.customerID = customerID
        self.transactionNumber = transactionNumber
        self.note = note
    }
}
