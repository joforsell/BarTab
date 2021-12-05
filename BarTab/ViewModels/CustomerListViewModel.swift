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
        
    func removeCustomer(_ id: String) {
        if let index = customerRepository.customers.firstIndex(where: { $0.id == id }) {
            let customer = customerRepository.customers[index]
            customerRepository.removeCustomer(customer)
        }
    }
    
    func updateKey(of customer: Customer, with key: String) {
        guard let customerID = customer.id else { return }
        guard let index = customerRepository.customers.firstIndex(where: { $0.id == customerID }) else { return }
            let customer = customerRepository.customers[index]
            customerRepository.updateKey(of: customer, with: key)
    }
        
    func addToBalance(of customer: Customer, by adjustment: Int) {
        guard let customerId = customer.id else { return }
        guard let index = customerRepository.customers.firstIndex(where: { $0.id == customerId }) else { return }
            var customer = customerRepository.customers[index]
            customer.balance += adjustment
            customerRepository.updateCustomer(customer)
    }
    
    func subtractFromBalance(of customer: Customer, by adjustment: Int) {
        guard let customerId = customer.id else { return }
        guard let index = customerRepository.customers.firstIndex(where: { $0.id == customerId }) else { return }
            var customer = customerRepository.customers[index]
            customer.balance -= adjustment
            customerRepository.updateCustomer(customer)
    }
    
    func customerBoughtWithKey(_ drink: Drink, key: String) {
        if let index = customerRepository.customers.firstIndex(where: { $0.key == key }) {
            var customer = customerRepository.customers[index]
            customer.balance -= drink.price
            customer.drinksBought.append(drink)
            customerRepository.updateCustomer(customer)
        } else {
            return
        }
    }
    
    func customerBought(_ drink: Drink, id: String) {
        if let index = customerRepository.customers.firstIndex(where: { $0.id == id }) {
            var customer = customerRepository.customers[index]
            customer.balance -= drink.price
            customer.drinksBought.append(drink)
            customerRepository.updateCustomer(customer)
        } else {
            return
        }
    }

    func sendEmails(from association: String?, completion: @escaping (Result<Bool, Error>) -> Void) {
        emailSender.sendEmails(to: customerRepository.customers, from: association) { result in
            completion(result)
        }
    }
}
