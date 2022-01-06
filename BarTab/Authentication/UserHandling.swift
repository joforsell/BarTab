//
//  UserRepository.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-09.
//

import FirebaseFirestore
import FirebaseAuth
import Combine
import Purchases
import UIKit

class UserHandling: ObservableObject {
    
    // MARK: - User profile
    
    static let shared = UserHandling()
    
    let db = Firestore.firestore().collection("users")
    
    @Published var user = User()
    @Published var userInfo: Purchases.PurchaserInfo? {
        didSet {
            subscriptionActive = userInfo?.entitlements["Full access"]?.isActive == true
        }
    }
    @Published var subscriptionActive: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadUser()
        userAuthStateDidChange()
    }
    
    func loadUser() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else { return }
                guard let data = try? document.data(as: User.self) else { return }
                
                UserHandling.shared.user = data
            }
    }
    
    func updateUserEmail(_ email: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData([ "email": email ] , merge: true)
    }
    
    func updateUserAssociation(_ association: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData([ "association": association ] , merge: true)
    }
    
    func updateUserTagUsage(_ isUsingTags: Bool) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData([ "usingTags": isUsingTags ] , merge: true)
    }
    
    
    // MARK: - User authentication state
    
    @Published var userAuthState: AuthState = .undefined
    
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
