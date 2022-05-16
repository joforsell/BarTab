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
        let newTransactionNumber = (customer.numberOfTransactions ?? 0) + 1
        
        return Transaction(name: drink.name, image: drink.image.rawValue, amount: drink.price, newBalance: customer.balance - drink.price, date: now, customerID: customer.id!, transactionNumber: newTransactionNumber)
    }
    
    func makeTransactions(customer: Customer, drinks: [Drink]) -> [Transaction] {
        let now = Date.now
        var transactions = [Transaction]()
        var accumulatedPrice = 0
        var newTransactionNumber = (customer.numberOfTransactions ?? 0) + 1
        for drink in drinks {
            accumulatedPrice += drink.price
            transactions.append(Transaction(name: drink.name, image: drink.image.rawValue, amount: drink.price, newBalance: customer.balance - accumulatedPrice, date: now, customerID: customer.id!, transactionNumber: newTransactionNumber))
            newTransactionNumber += 1
        }
        return transactions
    }

    static let errorDrink = DrinkViewModel(showingDecimals: true, drink: Drink(name: "Dryck saknas", price: 0))
    
    init() {
        self.isShowingConfirmationView = false
    }
}
