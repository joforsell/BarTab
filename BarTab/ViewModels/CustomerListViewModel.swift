//
//  UserViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI
import Combine
import Firebase

class CustomerListViewModel: ObservableObject {
    @Published var customerRepository = CustomerRepository()
    @Published var customerVMs = [CustomerViewModel]()
    private let emailSender = EmailSender()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(){
        customerRepository.$customers
            .debounce(for: 1, scheduler: RunLoop.main)
            .map { customers in
                customers.map { customer in
                    CustomerViewModel(customer: customer)
                }
            }
            .assign(to: \.customerVMs, on: self)
            .store(in: &subscriptions)
    }
    
    func addCustomer(name: String, balance: Int = 0, key: String = "", email: String) {
        let newCustomer = Customer(name: name, balance: balance, key: key, email: email)
        customerRepository.addCustomer(newCustomer)
    }
        
    func removeCustomer(_ customer: Customer) {
        customerRepository.removeCustomer(customer)
    }
    
    func updateName(of customer: Customer, to name: String) {
        guard customer.id != nil else { return }
        
        customerRepository.updateName(of: customer, to: name)
    }
    
    func updateEmail(of customer: Customer, to email: String) {
        guard customer.id != nil else { return }
        
        customerRepository.updateEmail(of: customer, to: email)
    }
    
    func updateKey(of customer: Customer, with key: String) {
        guard customer.id != nil else { return }
            
        customerRepository.updateKey(of: customer, with: key)
    }
        
    func addToBalance(of customer: Customer, by adjustment: Int) {
        guard customer.id != nil else { return }
        var newTransactionNumber = customer.numberOfTransactions ?? 1
        let now = Date()
        
        TransactionListViewModel.addTransaction(Transaction(name: "Added to balance", image: "addedBalance", amount: adjustment, newBalance: customer.balance + adjustment, date: now, customerID: customer.id!, transactionNumber: newTransactionNumber))
        customerRepository.addToBalanceOf(customer, by: adjustment)
        newTransactionNumber += 1
        customerRepository.updateTransactionNumber(of: customer, to: newTransactionNumber)
    }
    
    func subtractFromBalance(of customer: Customer, by adjustment: Int) {
        guard customer.id != nil else { return }
        var newTransactionNumber = (customer.numberOfTransactions ?? 0) + 1
        let now = Date()
        
        TransactionListViewModel.addTransaction(Transaction(name: "Removed from balance", image: "removedBalance", amount: adjustment, newBalance: customer.balance - adjustment, date: now, customerID: customer.id!, transactionNumber: newTransactionNumber))
        customerRepository.subtractFromBalanceOf(customer, by: adjustment)
        newTransactionNumber += 1
        customerRepository.updateTransactionNumber(of: customer, to: newTransactionNumber)
    }
    
    func customerBoughtWithKey(_ drinks: [Drink], key: String) {
        if drinks.count == 1 {
            customerRepository.subtractFromBalanceOfKeyHolder(with: key, by: drinks.first!.price)
        } else if drinks.count > 1 {
            let drinkPrices = drinks.map { $0.price }
            let sum = drinkPrices.reduce(into: 0) { $0 += $1 }
            customerRepository.subtractFromBalanceOfKeyHolder(with: key, by: sum)
        } else {
            return
        }
    }
    
    func customerWithKey(_ key: String, completion: @escaping (Result<Customer, Error>) -> ()) {
        customerRepository.getCustomerWithKey(key) { result in
            completion(result)
        }
    }
    
    func customerBought(_ drinks: [Drink], customer: Customer) {
        guard customer.id != nil else { return }
        
        if drinks.count == 1 {
            var newTransactionNumber = customer.numberOfTransactions ?? 1
            let drink = drinks.first!
            let now = Date()

            customerRepository.subtractFromBalanceOf(customer, by: drink.price)
            TransactionListViewModel.addTransaction(Transaction(name: drink.name, image: drink.image.rawValue, amount: drink.price, newBalance: customer.balance - drink.price, date: now, customerID: customer.id!, transactionNumber: newTransactionNumber))
            newTransactionNumber += 1
            customerRepository.updateTransactionNumber(of: customer, to: newTransactionNumber)
        } else if drinks.count > 1 {
            let drinkPrices = drinks.map { $0.price }
            let sum = drinkPrices.reduce(into: 0) { $0 += $1 }
            let now = Date()
            var accumulatedPrice = 0
            var newTransactionNumber = customer.numberOfTransactions ?? 1
            
            customerRepository.subtractFromBalanceOf(customer, by: sum)
            for drink in drinks {
                accumulatedPrice += drink.price
                TransactionListViewModel.addTransaction(Transaction(name: drink.name, image: drink.image.rawValue, amount: drink.price, newBalance: customer.balance - accumulatedPrice, date: now, customerID: customer.id!, transactionNumber: newTransactionNumber))
                newTransactionNumber += 1
            }
            customerRepository.updateTransactionNumber(of: customer, to: newTransactionNumber)
        } else {
            return
        }
    }
    
    func sendEmails(from user: User, to customers: [Customer], with message: String, methods: [PaymentSelection]) async throws {
        try await EmailSender.sendEmails(to: customers, from: user, with: message, methods: methods)
    }
    
    func oneTimeCustomerBalanceAdjustment(for user: User) {
        for customerVM in customerVMs {
            customerRepository.updateBalance(of: customerVM.customer, to: customerVM.customer.balance * 100)
        }
    }
}
