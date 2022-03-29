//
//  Currency.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-03-16.
//

import Foundation
import SwiftUI

enum Currency: String, CaseIterable, Codable {
    case sek, dkr, nok, usd, cad, eur, gbp
    
    static func display(_ amount: Float, with user: User) -> String {
        let formattedAmount = user.showingDecimals ? String(format: "%.2f", amount) : String(format: "%.0f", amount)
        switch user.currency {
        case sek, dkr, nok:
            return "\(formattedAmount) kr"
        case usd, cad:
            if amount < 0 {
                let redactedAmountString = String(formattedAmount).replacingOccurrences(of: "-", with: "")
                return "-$\(redactedAmountString)"
            }
            return "$\(formattedAmount)"
        case eur:
            if amount < 0 {
                let redactedAmountString = String(formattedAmount).replacingOccurrences(of: "-", with: "")
                return "-€\(redactedAmountString)"
            }
            return "€\(formattedAmount)"
        case gbp:
            if amount < 0 {
                let redactedAmountString = String(formattedAmount).replacingOccurrences(of: "-", with: "")
                return "-£\(redactedAmountString)"
            }
            return "£\(formattedAmount)"
        }
    }
    
    static func add(_ amount: Float, with user: User) -> String {
        let formattedAmount = user.showingDecimals ? String(format: "%.2f", amount) : String(format: "%.0f", amount)
        switch user.currency {
        case sek, dkr, nok:
            return "+\(formattedAmount) kr"
        case usd, cad:
            return "+$\(formattedAmount)"
        case eur:
            return "+€\(formattedAmount)"
        case gbp:
            return "+£\(formattedAmount)"
        }
    }

    static func remove(_ amount: Float, with user: User) -> String {
        let formattedAmount = user.showingDecimals ? String(format: "%.2f", amount) : String(format: "%.0f", amount)
        switch user.currency {
        case sek, dkr, nok:
            return "-\(formattedAmount) kr"
        case usd, cad:
            return "-$\(formattedAmount)"
        case eur:
            return "-€\(formattedAmount)"
        case gbp:
            return "-£\(formattedAmount)"
        }
    }

}
