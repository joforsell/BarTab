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
    @Published var userHandling = UserHandling()
    @Published var isUserAuthenticated: AuthState = .undefined
    
    var cancellables = Set<AnyCancellable>()

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
    
    func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard

        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil {
                return true
            } else {
                defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
                return false
            }
        }

}
