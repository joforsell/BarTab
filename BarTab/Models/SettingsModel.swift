//
//  SettingsModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-01.
//

import Foundation

struct Settings: Codable {
    var usingTag: Bool
    var requestingPassword: Bool
    
    init(usingTag: Bool = false, requestingPassword: Bool = true) {
        self.usingTag = usingTag
        self.requestingPassword = requestingPassword
    }
}
