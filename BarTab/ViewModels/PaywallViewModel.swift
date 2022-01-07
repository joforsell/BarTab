//
//  PaywallViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-01-02.
//

import Foundation
import Purchases
import SwiftUI

class PaywallViewModel: ObservableObject {
    @Published var selectedSub: Subscription = .monthly
    @Published var offerings: Purchases.Offering?
    
    init() {
        fetchOfferings()
    }
    
    var continueButtonText: String {
        switch selectedSub {
        case .monthly:
            return "Sedan 49kr / månad"
        case .annual:
            return "Sedan 499kr / år"
        case .lifetime:
            return "Sedan en engångsavgift på 1699kr"
        }
    }
    
    enum Subscription: Int {
        case monthly
        case annual
        case lifetime
    }
    
    func fetchOfferings() {
        Purchases.shared.offerings { offerings, error in
            if let offering = offerings?.current {
                self.offerings = offering
            }
        }
    }
    
    func purchase(package: Purchases.Package, completion: @escaping (Bool) -> ()) {
        Purchases.shared.purchasePackage(package) { _, _, error, userCancelled in
            if error == nil, !userCancelled {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
