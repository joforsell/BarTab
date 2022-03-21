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
        
        let now = Date()
        TransactionListViewModel.addTransaction(Transaction(name: "Added to balance", image: "addedBalance", amount: adjustment, newBalance: (customer.balance + adjustment), date: now, customerID: customer.id!))
        customerRepository.addToBalanceOf(customer, by: adjustment)
    }
    
    func subtractFromBalance(of customer: Customer, by adjustment: Int) {
        guard customer.id != nil else { return }
        
        let now = Date()
        TransactionListViewModel.addTransaction(Transaction(name: "Removed from balance", image: "removedBalance", amount: adjustment, newBalance: (customer.balance - adjustment), date: now, customerID: customer.id!))
        customerRepository.subtractFromBalanceOf(customer, by: adjustment)
    }
    
    func customerBoughtWithKey(_ drink: Drink, key: String) {
        customerRepository.subtractFromBalanceOfKeyHolder(with: key, by: drink.price)
    }
    
    func customerWithKey(_ key: String, completion: @escaping (Result<Customer, Error>) -> ()) {
        customerRepository.getCustomerWithKey(key) { result in
            completion(result)
        }
    }
    
    func customerBought(_ drink: Drink, customer: Customer) {
        guard customer.id != nil else { return }
        
        customerRepository.subtractFromBalanceOf(customer, by: drink.price)
    }
    
    func sendEmails(from user: User, to customers: [Customer]) async throws {
        try await EmailSender.sendEmails(to: customers, from: user)
    }
}
