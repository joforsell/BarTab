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
            subscriptionActive = userInfo?.entitlements["Full access"]?.isActive == true
        }
    }
    @Published var subscriptionActive: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadUser()
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
    
    func updateColumnCount(_ columnCount: Int) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData([ "drinkCardColumns": columnCount ] , merge: true)
    }
    
    func updateDrinkSorting(_ drinkSorting: DrinkListViewModel.DrinkSorting) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.document(userID).setData([ "drinkSorting": drinkSorting.rawValue ] , merge: true)
    }
}
