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
    @Published var userAuthState: AuthState = .undefined
    
    init() {
        userAuthStateDidChange()
    }
    
    enum AuthState {
        case undefined, signedOut, signedIn
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
                            if info?.entitlements["Full access"]?.isActive == true {
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
