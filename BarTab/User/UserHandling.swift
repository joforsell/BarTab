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
    @Published var user = User()
    @Published var userInfo: Purchases.PurchaserInfo? {
        didSet {
            subscriptionActive = userInfo?.entitlements["all_access"]?.isActive == true
        }
    }
    @Published var subscriptionActive: Bool = false
    @Published var userError: UserError? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadUser()
        
        print("Initializing userHandler...")
    }
        
    let db = Firestore.firestore().collection("users")
    
    func loadUser() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else { return }
                guard let data = try? document.data(as: User.self) else { return }
                
                self.user = data
            }
        
        print("Calling loadUser...")
    }
    
    func updateUserEmail(_ email: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData([ "email" : email ] , merge: true)
        print("Updating email...")
    }
    
    func updateUserAssociation(_ association: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData([ "association" : association ] , merge: true)
        print("Updating association...")
    }
    
    func updateUserTagUsage(_ isUsingTags: Bool) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData([ "usingTags" : isUsingTags ] , merge: true)
    }
    
    func updateColumnCount(_ columnCount: Int) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData([ "drinkCardColumns" : columnCount ] , merge: true)
    }
    
    func updateDrinkSorting(_ drinkSorting: DrinkListViewModel.DrinkSorting) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData([ "drinkSorting" : drinkSorting.rawValue ] , merge: true)
    }
    
    func deleteUser(completion: @escaping (Result<Bool, Error>) -> ()) {
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    static func resetPassword(for email: String, completion: @escaping (UserError?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    return completion(UserError.convertedError(errorCode))
                }
            }
        }
    }
    
    static func createUser(withEmail email: String, password: String, completion: @escaping (UserError?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    return completion(UserError.convertedError(errorCode))
                }
            }
        }
    }
    
    static func signIn(withEmail email: String, password: String, completion: @escaping (UserError?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    return completion(UserError.convertedError(errorCode))
                }
            }
        }
    }
    
    func signOut(completion: @escaping (Bool) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            print("Kunde inte logga ut: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func linkEmailCredential(withEmail email: String, password: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        Auth.auth().currentUser?.link(with: credential) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
}
