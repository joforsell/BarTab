//
//  UserSettingsViewModel.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-01-18.
//

import Foundation
import Purchases
import Combine

class UserSettingsViewModel: ObservableObject {
    @Published var purchaser: Purchases.PurchaserInfo?
    @Published var firstSeenAsString = "-"
    @Published var expireDateAsString = "-"
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        Purchases.shared.purchaserInfo { purchaserInfo, error in
            self.purchaser = purchaserInfo
        }
        
        $purchaser
            .map {
                guard self.purchaser != nil else { return "-" }
                
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                formatter.locale = Locale(identifier: "sv_SE")
                let dateString = formatter.string(from: $0!.firstSeen)
                return dateString
                }
            .assign(to: \.firstSeenAsString, on: self)
            .store(in: &cancellables)
        
        $purchaser
            .map {
                guard self.purchaser != nil else { return "-" }
                
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                formatter.locale = Locale(identifier: "sv_SE")
            
                guard let expDate = $0!.latestExpirationDate else { return "-" }
                
                let dateString = formatter.string(from: expDate)
                return dateString
                }
            .assign(to: \.expireDateAsString, on: self)
            .store(in: &cancellables)

    }
}
