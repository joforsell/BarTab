//
//  PaymentMethod.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-04-25.
//

import Foundation
import SwiftUI

enum PaymentMethod: String, Codable, Hashable {
    case swish
    case bankAccount
    case plusgiro
    case venmo
    case paypal
    case cashApp
}

struct PaymentSelection: Codable, Hashable {
    let method: PaymentMethod
    var info: String
    var active: Bool
    var localizedString: String {
        switch method {
        case .swish:
            return String(format: NSLocalizedString("Swish", comment: ""))
        case .bankAccount:
            return String(format: NSLocalizedString("Bank Account", comment: ""))
        case .plusgiro:
            return String(format: NSLocalizedString("Plusgiro", comment: ""))
        case .venmo:
            return String(format: NSLocalizedString("Venmo", comment: ""))
        case .paypal:
            return String(format: NSLocalizedString("PayPal", comment: ""))
        case .cashApp:
            return String(format: NSLocalizedString("Cash App", comment: ""))
        }
    }
}
