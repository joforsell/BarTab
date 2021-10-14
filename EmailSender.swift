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
    
    func sendEmails(to customers: [Customer], from association: String?) {
        for customer in customers {
            db.collection("mail").addDocument(data: [
                "to" : customer.email,
                "message" : [
                    "subject" : "Nuvarande saldo hos \(association ?? "BarTab")",
                    "html" : "Hej \(customer.name)! Ditt nuvarande saldo är \(customer.balance)."
                ]
            ]) { error in
                if let error = error {
                    print("Fel vid skrivande av dokument: \(error)")
                } else {
                    print("Dokumentet skrevs.")
                }
            }
        }
    }
}
