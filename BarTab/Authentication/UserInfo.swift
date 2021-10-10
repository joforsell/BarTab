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
    @Published var user: User = .init(uid: "", displayName: "", email: "")
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    func configureFirebaseStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (_, user) in
            guard let _ = user else  {
                self.isUserAuthenticated = .signedOut
                return
            }
            self.isUserAuthenticated = .signedIn
//            UserHandling.retrieveUser(uid: user.uid) { result in
//                switch result {
//                case .failure(let error):
//                    print(error.localizedDescription)
//                case .success(let user):
//                    self.user = user
//                }
//            }
        })
    }
}
