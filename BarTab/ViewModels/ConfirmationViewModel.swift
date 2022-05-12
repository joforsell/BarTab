//
//  ConfirmationViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-05.
//

import Foundation

class ConfirmationViewModel: ObservableObject {
    @Published var isShowingConfirmationView: Bool
    @Published var selectedDrink: DrinkViewModel?
    
    func makeTransaction(customer: Customer, drink: Drink) -> Transaction {
        let now = Date.now
        return Transaction(name: drink.name, image: drink.image.rawValue, amount: (round(drink.price * 100) / 100.0), newBalance: (round((customer.balance - drink.price) * 100) / 100.0), date: now, customerID: customer.id!)
    }
    
    func makeTransactions(customer: Customer, drinks: [Drink]) -> [Transaction] {
        let now = Date.now
        var transactions = [Transaction]()
        for drink in drinks {
            transactions.append(Transaction(name: drink.name, image: drink.image.rawValue, amount: (round(drink.price * 100) / 100.0), newBalance: (round((customer.balance - drink.price) * 100) / 100.0), date: now, customerID: customer.id!))
        }
        return transactions
    }

    static let errorDrink = DrinkViewModel(showingDecimals: true, drink: Drink(name: "Dryck saknas", price: 0))
    
    init() {
        self.isShowingConfirmationView = false
    }
}
