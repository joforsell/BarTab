//
//  BalanceUpdateEmailViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-04-19.
//

import Foundation

class BalanceUpdateEmailViewModel: ObservableObject {
    @Published var customerVMs: [CustomerViewModel]
    @Published var message = ""
    
    init(customerVMs: [CustomerViewModel]) {
        self.customerVMs = customerVMs
    }
}
