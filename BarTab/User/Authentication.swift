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
    
    init() {
        userAuthStateDidChange()
    }
    
    enum AuthState {
        case signedIn, signedOut, subscribed
    }
        
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    func userAuthStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { _, user in
            if let uid = user?.uid {
                Purchases.shared.logIn(uid) { info, _, error in
                    if let err = error {
                        print("Sign in error: \(err.localizedDescription)")
                    } else {
                        Purchases.shared.purchaserInfo { info, error in
                            if info?.entitlements["all_access"]?.isActive == true {
                                self.userAuthState = .subscribed
                            } else {
                                self.userAuthState = .signedIn
                            }
                        }
                    }
                }
            } else {
                Purchases.shared.logOut { info, error in
                    self.userAuthState = .signedOut
                }
            }
        }
    }
}
