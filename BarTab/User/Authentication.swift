//
//  Authentication.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-10.
//

import SwiftUI
import FirebaseAuth
import Purchases

class Authentication: ObservableObject {
    @Published var userAuthState: AuthState = .signedOut
    let purchases: Purchases
    
    init(purchases: Purchases = Purchases.shared) {
        self.purchases = purchases
        userAuthStateDidChange()
    }
        
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    func userAuthStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if user?.uid == "8dMgnCawJxaagSOJD9sauSCqHFR2" || user?.uid == "NJvmzctlkeafv620gWGFh4wGbbp2" {
                self?.userAuthState = .subscribed
            } else {
                if let uid = user?.uid {
                    self?.purchases.logIn(uid) { info, _, error in
                        if let err = error {
                            print("Sign in error: \(err.localizedDescription)")
                        } else {
                            self?.purchases.purchaserInfo { info, error in
                                if info?.entitlements["all_access"]?.isActive == true {
                                    self?.userAuthState = .subscribed
                                } else {
                                    self?.userAuthState = .signedIn
                                }
                            }
                        }
                    }
                } else {
                    self?.purchases.logOut { info, error in
                        self?.userAuthState = .signedOut
                    }
                }
            }
        }
    }
    
    enum AuthState {
        case signedIn, signedOut, subscribed
    }

}
