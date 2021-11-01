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
    
    init(uid: String, email: String, association: String? = "") {
        self.uid = uid
        self.email = email
        self.association = association
    }
}

extension User {
    init?(documentData: [String : Any]) {
        let uid = documentData[UserKeys.User.uid] as? String ?? ""
        let email = documentData[UserKeys.User.email] as? String ?? ""
        let association = documentData[UserKeys.User.association] as? String ?? ""
        
        self.init(  uid: uid,
                    email: email,
                    association: association
        )
    }
    
    static func dataDict(uid: String, email: String, association: String? = "") -> [String : Any] {
        var data: [String : Any]
        
        if association != "" {
            data = [
                UserKeys.User.uid: uid,
                UserKeys.User.email: email,
                UserKeys.User.association: association!
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
