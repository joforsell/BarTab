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
import Purchases

class CustomerRepository: ObservableObject {
        
    @Published var customers = [Customer]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        let userId = Auth.auth().currentUser?.uid
        
        Firestore.firestore().collection("customers")
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
            let _ = try Firestore.firestore().collection("customers").addDocument(from: addedCustomer)
        } catch {
            fatalError("Unable to encode user: \(error.localizedDescription)")
        }
    }
    
    func removeCustomer(_ customer: Customer) {
        if let customerID = customer.id {
            Firestore.firestore().collection("customers").document(customerID).delete() { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    func updateName(of customer: Customer, to name: String) {
        Firestore.firestore().collection("customers").document(customer.id!).updateData([ "name" : name ])
    }
    
    func updateEmail(of customer: Customer, to email: String) {
        Firestore.firestore().collection("customers").document(customer.id!).updateData([ "email" : email ])
    }
    
    func addToBalanceOf(_ customer: Customer, by adjustment: Float) {
        Firestore.firestore().collection("customers").document(customer.id!).updateData([ "balance" : FieldValue.increment(Int64(round(adjustment * 100) / 100.0)) ])
    }
    
    func subtractFromBalanceOf(_ customer: Customer, by adjustment: Float) {
        Firestore.firestore().collection("customers").document(customer.id!).updateData([ "balance" : FieldValue.increment(Int64(-(round(adjustment * 100) / 100.0))) ])
    }
    
    func subtractFromBalanceOfKeyHolder(with key: String, by adjustment: Float) {
        Firestore.firestore().collection("customers").whereField("key", isEqualTo: key).getDocuments() { snapshot, error in
            guard snapshot != nil else { return }
            for document in snapshot!.documents {
                guard let data = try? document.data(as: Customer.self) else { return }
                
                Firestore.firestore().collection("customers").document(data.id!).updateData([ "balance" : FieldValue.increment(Int64(-adjustment)) ])
            }
        }

    }
    
    func getCustomerWithKey(_ key: String, completion: @escaping (Result<Customer, Error>) -> ()) {
        Firestore.firestore().collection("customers").whereField("key", isEqualTo: key).getDocuments() { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                for document in snapshot!.documents {
                    guard let data = try? document.data(as: Customer.self) else { return }
                    
                    completion(.success(data))
                }
            }
        }
    }
    
    func updateKey(of customer: Customer, with key: String) {
        Firestore.firestore().collection("customers").document(customer.id!).updateData(["key" : key])
    }
}
