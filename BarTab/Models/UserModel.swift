//
//  UserModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-09.
//

import Foundation

struct User: Codable {
    var uid: String
    var displayName: String
    var email: String
    
    init(uid: String, displayName: String, email: String) {
        self.uid = uid
        self.displayName = displayName
        self.email = email
    }
}

extension User {
    init?(documentData: [String : Any]) {
        let uid = documentData[UserKeys.User.uid] as? String ?? ""
        let displayName = documentData[UserKeys.User.displayName] as? String ?? ""
        let email = documentData[UserKeys.User.email] as? String ?? ""
        
        self.init(  uid: uid,
                    displayName: displayName,
                    email: email
        )
    }
    
    static func dataDict(uid: String, displayName: String, email: String) -> [String : Any] {
        var data: [String : Any]
        
        if displayName != "" {
            data = [
                UserKeys.User.uid: uid,
                UserKeys.User.displayName: displayName,
                UserKeys.User.email: email
            ]
        } else {
            data = [
                UserKeys.User.uid: uid,
                UserKeys.User.email: email
            ]
        }
        return data
    }
}
