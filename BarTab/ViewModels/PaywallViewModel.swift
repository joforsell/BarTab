//
//  PaywallViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-01-02.
//

import Foundation

class PaywallViewModel: ObservableObject {
    @Published var selectedSub: Subscription = .monthly
    var continueButtonText: String {
        switch selectedSub {
        case .monthly:
            return "Sedan 49kr / månad"
        case .yearly:
            return "Sedan 499kr / år"
        case .lifetime:
            return "Sedan en engångsavgift på 1699kr"
        }
    }
    
    enum Subscription: Int {
        case monthly
        case yearly
        case lifetime
    }
}
