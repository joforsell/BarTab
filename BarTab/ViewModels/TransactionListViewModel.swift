//
//  TransactionListViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-03-09.
//

import Foundation
import FirebaseFirestore

class TransactionListViewModel: ObservableObject {
    
    @Published var transactions = [Transaction]()
    
    init(customer: Customer) {
        loadTransactions(of: customer)
    }
    
    private func loadTransactions(of customer: Customer) {
        guard let id = customer.id else { return }
        Firestore.firestore().collection("transactions")
            .whereField("customerID", isEqualTo: id)
            .order(by: "date")
            .getDocuments() { querySnapshot, error in
                if let err = error {
                } else {
                    if let snapshot = querySnapshot {
                        self.transactions = snapshot.documents.compactMap { document in
                            try? document.data(as: Transaction.self)
                        }
                    }
                }
            }
    }
    
    static func addTransaction(_ transaction: Transaction) {
        do {
            let _ = try Firestore.firestore().collection("transactions").addDocument(from: transaction)
        } catch {
            fatalError("Unable to encode transaction: \(error.localizedDescription)")
        }
    }
    
    static func removeTransaction(_ transaction: Transaction) {
        if let transactionID = transaction.id {
            Firestore.firestore().collection("transactions").document(transactionID).delete() { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    func oneTimeTransactionAdjustment(for: User) {
        for transaction in transactions {
            if let transactionID = transaction.id {
                Firestore.firestore().collection("transactions").document(transactionID).updateData(["amount": transaction.amount * 100])
                Firestore.firestore().collection("transactions").document(transactionID).updateData(["newBalance": transaction.newBalance * 100])
            }
        }
    }
}
