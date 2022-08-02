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
import FirebaseAuth

class PaywallViewModel: ObservableObject {
    @Published var selectedSub: Subscription = .annual
    @Published var offerings: Purchases.Offering?
    var authentication: Authentication?
        
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
    
    func handleSubscribeButton() {
        switch selectedSub {
        case .monthly:
            guard let monthlyPackage = offerings?.monthly else { return }
            return purchase(package: monthlyPackage) { [weak self] completed in
                if completed {
                    self?.authentication?.userAuthState = .subscribed
                    if let user = Auth.auth().currentUser {
                        Purchases.shared.setEmail(user.email)
                    }
                }
            }
        case .annual:
            guard let annualPackage = offerings?.annual else { return }
            return purchase(package: annualPackage) { [weak self] completed in
                if completed {
                    self?.authentication?.userAuthState = .subscribed
                    if let user = Auth.auth().currentUser {
                        Purchases.shared.setEmail(user.email)
                    }
                }
            }
        case .lifetime:
            guard let lifetimePackage = offerings?.lifetime else { return }
            return purchase(package: lifetimePackage) { [weak self] completed in
                if completed {
                    self?.authentication?.userAuthState = .subscribed
                    if let user = Auth.auth().currentUser {
                        Purchases.shared.setEmail(user.email)
                    }
                }
            }
        }

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
                    _ = FunctionsErrorCode(rawValue: error.code)
                    _ = error.localizedDescription
                    _ = error.userInfo[FunctionsErrorDetailsKey]
                }
            }
        }
    }
    
    func setup(_ authentication: Authentication) {
        self.authentication = authentication
    }
}
