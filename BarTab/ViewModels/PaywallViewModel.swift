//
//  PaywallViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-01-02.
//

import Foundation
import Purchases
import SwiftUI
import FirebaseFunctions

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
    
    func transferData(from oldUser: String, to newUser: String) {
        let functions = Functions.functions()
        
        functions.httpsCallable("transferData").call(["oldUser": oldUser, "newUser": newUser]) { _, error in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    print(code)
                    print(message)
                    print(details)
                }
            }
        }
    }
}
