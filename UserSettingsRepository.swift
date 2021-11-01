////
////  UserSettingsRepository.swift
////  BarTab
////
////  Created by Johan Forsell on 2021-10-21.
////
//
//import Foundation
//import FirebaseAuth
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//
//class UserSettingsRepository: ObservableObject {
//
//    let db = Firestore.firestore()
//
//    @Published var settings = UserSettings()
//
//    init() {
//        loadData()
//    }
//
//    func loadData() {
//        let userId = Auth.auth().currentUser?.uid
//
//        db.collection("usersettings")
//            .document(userId!)
//            .addSnapshotListener { (documentSnapshot, error) in
//            if let documentSnapshot = documentSnapshot {
//                self.settings = try!try!try!try!try! documentSnapshot.data(as: UserSettings.self) as! UserSettings
//            }
//        }
//    }
//
//    func addSettings(_ settings: UserSettings) {
//        do {
//            let docName = Auth.auth().currentUser?.uid
//            let _ = try db.collection("usersettings").document(docName!).setData(from: settings)
//        } catch {
//            fatalError("Unable to encode settings: \(error.localizedDescription)")
//        }
//    }
//
//    func updateSettings(_ settings: UserSettings) {
//        if let settingsID = settings.id {
//            do {
//                try db.collection("usersettings").document(settingsID).setData(from: settings)
//            } catch {
//                fatalError("Unable to encode settings: \(error.localizedDescription)")
//            }
//        }
//    }
//}
