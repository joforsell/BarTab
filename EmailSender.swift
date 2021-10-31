//
//  EmailSender.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-14.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class EmailSender {
    
    let db = Firestore.firestore()
    
    func sendEmails(to customers: [Customer], from association: String?, completion: @escaping (Result<Bool, Error>) -> ()) {
        for customer in customers {
            let customerName = customer.name
            let firstName = customerName.components(separatedBy: " ").first
            
            db.collection("mail").addDocument(data: [
                "to" : customer.email,
                "message" : [
                    "subject" : "Nuvarande saldo hos \(association ?? "BarTab")",
                    "html" : "Hej \(firstName ?? "")! Ditt nuvarande saldo är \(customer.balance)."
                ]
            ]) { error in
                if let error = error {
                    print("Fel vid skrivande av dokument: \(error)")
                    completion(.failure(error))
                } else {
                    print("Dokumentet skrevs.")
                    completion(.success(true))
                }
            }
        }
    }
}
