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
        
    static func sendEmails(to customers: [Customer], from user: User, completion: @escaping (Result<Bool, Error>) -> ()) {
        for customer in customers {
            let customerName = customer.name
            let firstName = customerName.components(separatedBy: " ").first
            
            if  !customer.email.isEmpty {
                
                Firestore.firestore().collection("mail").addDocument(data: [
                    "to" : customer.email,
                    "message" : [
                        "subject" : "Nuvarande saldo hos \(user.association ?? "BarTab")",
                        "html" : "Hej \(firstName ?? "")! Ditt nuvarande saldo är \(customer.balance).</br></br>Frågor? Maila: \(user.email ?? "Mailadress saknas")"
                    ]
                ]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(true))
                    }
                }
            }
        }
    }
}
