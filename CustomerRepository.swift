//
//  CustomerRepository.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-03.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class CustomerRepository: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var customers = [Customer]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        let userId = Auth.auth().currentUser?.uid
        
        db.collection("customers")
            .whereField("userId", isEqualTo: userId as Any)
            .addSnapshotListener { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                self.customers = querySnapshot.documents.compactMap { document in
                    try? document.data(as: Customer.self)
                }
            }
        }
    }
    
    func addCustomer(_ customer: Customer) {
        do {
            var addedCustomer = customer
            addedCustomer.userId = Auth.auth().currentUser?.uid
            let _ = try db.collection("customers").addDocument(from: addedCustomer)
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
        if let customerID = customer.id {
            do {
                try db.collection("customers").document(customerID).setData(from: customer)
            } catch {
                fatalError("Unable to encode user: \(error.localizedDescription)")
            }
        }
    }
    
    func updateKey(of customer: Customer, with key: String) {
        if let customerID = customer.id {
            db.collection("customers").document(customerID).updateData(["key" : key])
        }
    }
    
    func addTransaction(_ transaction: Transaction, to customer: Customer) {
        if let customerID = customer.id {
            let transactionDictionary = ["amount" : transaction.amount, "description" : transaction.description, "id" : transaction.id, "createdTime" : transaction.createdTime] as [String : Any]
            db.collection("customers").document(customerID).updateData([
                "transactions" : FieldValue.arrayUnion([transactionDictionary])
            ])
        }
    }
}
