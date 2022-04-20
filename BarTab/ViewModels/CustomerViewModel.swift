//
//  CustomerViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-16.
//

import SwiftUI
import Combine

class CustomerViewModel: ObservableObject, Identifiable {
    @Published var customerRepository = CustomerRepository()
    @Published var customer: Customer
    @Published var name = ""
    @Published var email = ""
    @Published var balanceAsString = ""
    @Published var checked = false
    
    var id = ""
    var balanceColor: Color {
        if customer.balance > 0 {
            return Color("Lead")
        } else {
            return Color("Deficit")
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(customer: Customer) {
        self.customer = customer
        
        $customer
            .compactMap { customer in
                customer.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        
        $customer
            .compactMap { customer in
                customer.name
            }
            .assign(to: \.name, on: self)
            .store(in: &cancellables)
        
        $customer
            .compactMap { customer in
                customer.email
            }
            .assign(to: \.email, on: self)
            .store(in: &cancellables)

        
        $customer
            .compactMap { customer in
                String(customer.balance)
            }
            .assign(to: \.balanceAsString, on: self)
            .store(in: &cancellables)
        
        $name
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { name in
                self.customerRepository.updateName(of: self.customer, to: name)
            }
            .store(in: &cancellables)
        
        $email
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { email in
                self.customerRepository.updateEmail(of: self.customer, to: email)
            }
            .store(in: &cancellables)
    }
}
