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
    enum AuthState {
        case undefined, signedOut, signedIn
    }
    
    @Published var isUserAuthenticated: AuthState = .undefined
    @Published var user: User = .init(uid: "", email: "", association: "")
    
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

            if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
                print("App already launched: \(isAppAlreadyLaunchedOnce)")
                return true
            } else {
                defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
                print("App launched first time")
                return false
            }
        }

}
