//
//  UserSettingsViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-01-18.
//

import Foundation
import Purchases
import SwiftUI

class UserSettingsViewModel: ObservableObject {
    @Environment(\.locale) var locale
    @Published var purchaser: Purchases.PurchaserInfo?
    @Published var expireDateAsString = "-"
    @Published var subscriptionType = ""
    
    init() {
        Purchases.shared.purchaserInfo { [weak self] purchaserInfo, error in
            guard let self = self else { return }
            self.purchaser = purchaserInfo
            self.expireDateAsString = self.formattedDate(purchaserInfo?.latestExpirationDate)
            self.subscriptionType = purchaserInfo?.activeSubscriptions.first?.localizedCapitalized ?? ""
        }
    }
    
    private func formattedDate(_ date: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        guard let expDate = date else { return "-" }

        return formatter.string(from: expDate)
    }
}
