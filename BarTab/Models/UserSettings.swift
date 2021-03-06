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
    var usingTag: Bool
    var requestingPassword: Bool
    
    init(usingTag: Bool = false, requestingPassword: Bool = true) {
        self.usingTag = usingTag
        self.requestingPassword = requestingPassword
    }
}

