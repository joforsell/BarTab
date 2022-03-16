//
//  CustomerModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import Foundation
import FirebaseFirestoreSwift

struct Customer: Codable, Identifiable {
    @DocumentID var id = UUID().uuidString
    var name: String
    var balance: Int
    var key: String
    var email: String
    var userId: String?
}
