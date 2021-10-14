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
    
    func removeCustomer(_ id: String) {
        if let index = customers.firstIndex(where: { $0.id == id }) {
            let customer = customers[index]
            customerRepository.removeCustomer(customer)
        }
    }
        
    func addToBalance(of id: String, by adjustment: Int) {
        if let index = customers.firstIndex(where: { $0.id == id }) {
            var customer = customers[index]
            customer.balance += adjustment
            customerRepository.updateCustomer(customer)
        } else {
            return
        }
    }
    
    func subtractFromBalance(of id: String, by adjustment: Int) {
        if let index = customers.firstIndex(where: { $0.id == id }) {
            var customer = customers[index]
            customer.balance -= adjustment
            customerRepository.updateCustomer(customer)
        } else {
            return
        }
    }
    
    func drinkBought(by key: String, for price: Int) {
        if let index = customers.firstIndex(where: { $0.key == key }) {
            customers[index].balance -= price
        } else {
            return
        }
    }
    
    func sendEmails(from association: String?) {
        emailSender.sendEmails(to: customers, from: association)
    }
}
