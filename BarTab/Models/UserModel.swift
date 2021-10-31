//
//  UserModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-09.
//

import Foundation

struct User: Codable {
    var uid: String
    var email: String
    var association: String?
    var settingsLoaded: Bool
    
    init(uid: String, email: String, association: String? = "", settingsLoaded: Bool = false) {
        self.uid = uid
        self.email = email
        self.association = association
        self.settingsLoaded = settingsLoaded
    }
}

extension User {
    init?(documentData: [String : Any]) {
        let uid = documentData[UserKeys.User.uid] as? String ?? ""
        let email = documentData[UserKeys.User.email] as? String ?? ""
        let association = documentData[UserKeys.User.association] as? String ?? ""
        let settingsLoaded = documentData[UserKeys.User.settingsLoaded] as? Bool ?? false
        
        self.init(  uid: uid,
                    email: email,
                    association: association,
                    settingsLoaded: settingsLoaded
        )
    }
    
    static func dataDict(uid: String, email: String, association: String? = "", settingsLoaded: Bool) -> [String : Any] {
        var data: [String : Any]
        
        if association != "" {
            data = [
                UserKeys.User.uid: uid,
                UserKeys.User.email: email,
                UserKeys.User.association: association!,
                UserKeys.User.settingsLoaded: settingsLoaded
            ]
        } else {
            data = [
                UserKeys.User.uid: uid,
                UserKeys.User.email: email,
                UserKeys.User.settingsLoaded: settingsLoaded
            ]
        }
        return data
    }
}
