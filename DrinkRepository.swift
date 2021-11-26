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

class DrinkRepository: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var drinks = [Drink]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        let userId = Auth.auth().currentUser?.uid
        
        db.collection("drinks")
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
            let _ = try db.collection("drinks").addDocument(from: addedDrink)
        } catch {
            fatalError("Unable to encode drink: \(error.localizedDescription)")
        }
    }
    
    func removeDrink(_ drink: Drink) {
        if let drinkID = drink.id {
            db.collection("drinks").document(drinkID).delete() { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    func updateDrink(_ drink: Drink) {
        if let drinkID = drink.id{
            do {
                try db.collection("drinks").document(drinkID).setData(from: drink)
            } catch {
                fatalError("Unable to encode drink: \(error.localizedDescription)")
            }
        }
    }
    
    func updateDrinkPrice(of drink: Drink, to price: Int) {
        if let drinkID = drink.id {
            db.collection("drinks").document(drinkID).updateData(["price" : price])
        }
    }
}
