//
//  UserSettings.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-19.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift

struct UserSettings: Codable {
    @DocumentID var id = UUID().uuidString
    var userId: String?
    var usingTag: Bool
    var requestingPassword: Bool
    
    init(userId: String, usingTag: Bool = false, requestingPassword: Bool = true) {
        self.userId = userId
        self.usingTag = usingTag
        self.requestingPassword = requestingPassword
    }
    
    init(usingTag: Bool = false, requestingPassword: Bool = true) {
        self.userId = Auth.auth().currentUser?.uid
        self.usingTag = usingTag
        self.requestingPassword = requestingPassword
    }
}
