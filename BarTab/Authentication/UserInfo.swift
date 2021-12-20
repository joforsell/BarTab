//
//  UserInfo.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-09.
//

import Foundation
import Firebase
import Combine

class UserInfo: ObservableObject {
    @Published var isUserAuthenticated: AuthState = .undefined
    
    enum AuthState {
        case undefined, signedOut, signedIn
    }
        
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    func configureFirebaseStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { _, user in
            guard let _ = user else  {
                self.isUserAuthenticated = .signedOut
                return
            }
            self.isUserAuthenticated = .signedIn
        }
    }
}
