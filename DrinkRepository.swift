//
//  DrinkRepository.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-04.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class DrinkRepository: ObservableObject {
        
    @Published var drinks = [Drink]()
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        loadData()
    }
    
    func loadData() {
        let userId = Auth.auth().currentUser?.uid
        
        Firestore.firestore().collection("drinks")
            .whereField("userId", isEqualTo: userId as Any)
            .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.drinks = querySnapshot.documents.compactMap { document in
                    try? document.data(as: Drink.self)
                }
            }
        }
    }
    
    func addDrink(_ drink: Drink) {
        do {
            var addedDrink = drink
            addedDrink.userId = Auth.auth().currentUser?.uid
            let _ = try Firestore.firestore().collection("drinks").addDocument(from: addedDrink)
        } catch {
            fatalError("Unable to encode drink: \(error.localizedDescription)")
        }
    }
    
    func removeDrink(_ drink: Drink) {
        Firestore.firestore().collection("drinks").document(drink.id!).delete() { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func updateDrinkPrice(of drink: Drink, to price: Int) {
        Firestore.firestore().collection("drinks").document(drink.id!).updateData(["price" : price])
    }
    
    func updateDrinkName(of drink: Drink, to name: String) {
        Firestore.firestore().collection("drinks").document(drink.id!).updateData(["name" : name])
    }
}
