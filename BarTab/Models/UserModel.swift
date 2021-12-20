//
//  UserModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-10-09.
//

import Foundation

struct User: Codable {
    var email: String?
    var association: String?
    var usingTags: Bool = false
}
