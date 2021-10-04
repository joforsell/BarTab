//
//  DrinkRepository.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-04.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class DrinkRepository: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var drinks = [Drink]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        db.collection("drinks").addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.drinks = querySnapshot.documents.compactMap { document in
                    try? document.data(as: Drink.self)
                }
            }
        }
    }
    
    func addDrink(_ drink: Drink) {
        do {
            let _ = try db.collection("drinks").addDocument(from: drink)
        } catch {
            fatalError("Unable to encode user: \(error.localizedDescription)")
        }
    }
}
