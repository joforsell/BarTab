//
//  CustomerViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-16.
//

import Foundation
import Combine

class CustomerViewModel: ObservableObject, Identifiable {
    @Published var customerRepository = CustomerRepository()
    @Published var customer: Customer
    
    var id = ""
        
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
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { customer in
                self.customerRepository.updateCustomer(customer)
            }
            .store(in: &cancellables)
    }
}
