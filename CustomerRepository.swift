//
//  CustomerRepository.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-03.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class CustomerRepository: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var customers = [Customer]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        db.collection("customers").addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.customers = querySnapshot.documents.compactMap { document in
                    try? document.data(as: Customer.self)
                }
            }
        }
    }
    
    func addCustomer(_ customer: Customer) {
        do {
            let _ = try db.collection("customers").addDocument(from: customer)
        } catch {
            fatalError("Unable to encode user: \(error.localizedDescription)")
        }
    }
    
    func removeCustomer(_ customer: Customer) {
        if let customerID = customer.id {
            db.collection("customers").document(customerID).delete() { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    func updateCustomer(_ customer: Customer) {
        if let customerID = customer.id{
            do {
                try db.collection("customers").document(customerID).setData(from: customer)
            } catch {
                fatalError("Unable to encode user: \(error.localizedDescription)")
            }
        }
    }
}
