//
//  UserViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI
import Combine
import Firebase

class CustomerViewModel: ObservableObject {
    @Published var customerRepository = CustomerRepository()
    @Published var customers = [Customer]()
    let emailSender = EmailSender()
    
    var subscriptions = Set<AnyCancellable>()
    
    init(){
        customerRepository.$customers
            .assign(to: \.customers, on: self)
            .store(in: &subscriptions)
    }
    
    func addCustomer(name: String, balance: Int, key: String, email: String) {
        let newCustomer = Customer(name: name, balance: balance, key: key, email: email)
        customerRepository.addCustomer(newCustomer)
    }
    
    func addCustomerWithoutKey(name: String, balance: Int, email: String) {
        let newCustomer = Customer(name: name, balance: balance, email: email)
        customerRepository.addCustomer(newCustomer)
    }
    
    func removeCustomer(_ id: String) {
        if let index = customers.firstIndex(where: { $0.id == id }) {
            let customer = customers[index]
            customerRepository.removeCustomer(customer)
        }
    }
        
    func addToBalance(of id: String, by adjustment: Int) {
        guard let index = customers.firstIndex(where: { $0.id == id }) else { return }
            var customer = customers[index]
            customer.balance += adjustment
            customerRepository.updateCustomer(customer)
    }
    
    func subtractFromBalance(of id: String, by adjustment: Int) {
        guard let index = customers.firstIndex(where: { $0.id == id }) else { return }
            var customer = customers[index]
            customer.balance -= adjustment
            customerRepository.updateCustomer(customer)
    }
    
    func customerBoughtWithKey(_ drink: Drink, key: String) {
        if let index = customers.firstIndex(where: { $0.key == key }) {
            var customer = customers[index]
            customer.balance -= drink.price
            customer.drinksBought.append(drink)
            customerRepository.updateCustomer(customer)
        } else {
            return
        }
    }
    
    func customerBought(_ drink: Drink, id: String) {
        if let index = customers.firstIndex(where: { $0.id == id }) {
            var customer = customers[index]
            customer.balance -= drink.price
            customer.drinksBought.append(drink)
            customerRepository.updateCustomer(customer)
        } else {
            return
        }
    }

    
    func sendEmails(from association: String?, completion: @escaping (Result<Bool, Error>) -> Void) {
        emailSender.sendEmails(to: customers, from: association) { result in
            completion(result)
        }
    }
}
