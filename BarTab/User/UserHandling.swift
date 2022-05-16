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
    @Published var paymentMethods: [PaymentSelection] = [PaymentSelection(method: .swish, info: "", active: false), PaymentSelection(method: .bankAccount, info: "", active: false), PaymentSelection(method: .plusgiro, info: "", active: false), PaymentSelection(method: .venmo, info: "", active: false), PaymentSelection(method: .paypal, info: "", active: false), PaymentSelection(method: .cashApp, info: "", active: false)]
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadUser()
        loadPaymentMethods()
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
    }
    
    func loadPaymentMethods() {
        let defaults = UserDefaults.standard
        if let paymentMethodData = defaults.object(forKey: "PaymentMethods") {
            let decoder = JSONDecoder()
            do {
                self.paymentMethods = try decoder.decode([PaymentSelection].self, from: paymentMethodData as! Data)
            } catch {
                print("Error decoding...")
            }
        }
    }
    
    func updateUserEmail(_ email: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData(["email": email], merge: true)
    }
    
    func updateUserAssociation(_ association: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData(["association": association], merge: true)
    }
    
    func updateUserPhoneNumber(_ number: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData(["number": number], merge: true)
    }
    
    func updateUserTagUsage(_ isUsingTags: Bool) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData(["usingTags": isUsingTags], merge: true)
    }
    
    func updateColumnCount(_ columnCount: Int) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData(["drinkCardColumns": columnCount], merge: true)
    }
    
    func updateDrinkSorting(_ drinkSorting: DrinkListViewModel.DrinkSorting) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData(["drinkSorting": drinkSorting.rawValue], merge: true)
    }
    
    func updateCurrency(_ currency: Currency) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData(["currency": currency.rawValue], merge: true)
    }
    
    func updateDecimalUsage(_ showingDecimals: Bool) {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        db.document(userID).setData(["showingDecimals": showingDecimals], merge: true)
    }
    
    func updatePaymentMethods() throws {
        let encoder = JSONEncoder()
        let json = try encoder.encode(paymentMethods)
        let defaults = UserDefaults.standard
        defaults.set(json, forKey: "PaymentMethods")
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
    
    static func signOut(completion: @escaping (Bool) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
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
    
    func setUpdatedState(to bool: Bool) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData(["isUpdated": bool], merge: true)
    }
}
