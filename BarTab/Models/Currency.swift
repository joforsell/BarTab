//
//  Currency.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-03-16.
//

import Foundation

enum Currency: String, CaseIterable, Codable {
    case sek, dkr, nok, usd, eur, gbp
    
    static func display(_ amount: Int, with currency: Currency) -> String {
        switch currency {
        case sek, dkr, nok:
            return "\(amount) kr"
        case usd:
            if amount < 0 {
                let redactedAmountString = String(amount).replacingOccurrences(of: "-", with: "")
                return "-$\(redactedAmountString)"
            }
            return "$\(amount)"
        case eur:
            if amount < 0 {
                let redactedAmountString = String(amount).replacingOccurrences(of: "-", with: "")
                return "-€\(redactedAmountString)"
            }
            return "€\(amount)"
        case gbp:
            if amount < 0 {
                let redactedAmountString = String(amount).replacingOccurrences(of: "-", with: "")
                return "-£\(redactedAmountString)"
            }
            return "£\(amount)"
        }
    }
    
    static func add(_ amount: Int, with currency: Currency) -> String {
        switch currency {
        case sek, dkr, nok:
            return "+\(amount) kr"
        case usd:
            return "+$\(amount)"
        case eur:
            return "+€\(amount)"
        case gbp:
            return "+£\(amount)"
        }
    }

    static func remove(_ amount: Int, with currency: Currency) -> String {
        switch currency {
        case sek, dkr, nok:
            return "-\(amount) kr"
        case usd:
            return "-$\(amount)"
        case eur:
            return "-€\(amount)"
        case gbp:
            return "-£\(amount)"
        }
    }

}
