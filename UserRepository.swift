//
//  UserRepository.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-03.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserRepository: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var users = [User]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.users = querySnapshot.documents.compactMap { document in
                    try? document.data(as: User.self)
                }
            }
        }
    }
    
    func addUser(_ user: User) {
        do {
            let _ = try db.collection("users").addDocument(from: user)
        } catch {
            fatalError("Unable to encode user: \(error.localizedDescription)")
        }
    }
    
    func removeUser(_ user: User) {
        if let userID = user.id {
            db.collection("users").document(userID).delete() { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    func updateUser(_ user: User) {
        if let userID = user.id{
            do {
                try db.collection("users").document(userID).setData(from: user)
            } catch {
                fatalError("Unable to encode user: \(error.localizedDescription)")
            }
        }
    }
}
