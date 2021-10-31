//
//  UserSettingsRepository.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserSettingsRepository {
    
    let db = Firestore.firestore()
    
    @Published var settings = UserSettings()
    
    init() {
        loadData()
    }
    
    func loadData() {
        let userId = Auth.auth().currentUser?.uid
        
        db.collection("usersettings")
            .whereField("userId", isEqualTo: userId as Any)
            .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let userId = document.data()["userId"] as? String ?? ""
                    let usingTag = document.data()["usingTag"] as? Bool ?? false
                    let requestingPassword = document.data()["requestingPassword"] as? Bool ?? true
                    
                    self.settings = UserSettings(userId: userId, usingTag: usingTag, requestingPassword: requestingPassword)
                }
            }
        }
    }
    
    func addSettings(_ settings: UserSettings) {
        do {
            var addedSettings = settings
            addedSettings.userId = Auth.auth().currentUser?.uid
            let _ = try db.collection("usersettings").addDocument(from: addedSettings)
        } catch {
            fatalError("Unable to encode settings: \(error.localizedDescription)")
        }
    }
    
    func updateSettings(_ settings: UserSettings) {
        if let settingsID = settings.id {
            do {
                try db.collection("usersettings").document(settingsID).setData(from: settings)
            } catch {
                fatalError("Unable to encode settings: \(error.localizedDescription)")
            }
        }
    }
}
