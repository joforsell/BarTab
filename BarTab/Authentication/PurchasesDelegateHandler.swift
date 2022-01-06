//
//  PurchasesDelegateHandler.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-01-06.
//

import Foundation
import Purchases
import SwiftUI

/*
 The class we'll use to publish PurchaserInfo data to our Magic Weather app.
 */

class PurchasesDelegateHandler: NSObject, ObservableObject {
    @EnvironmentObject var userHandler: UserHandling
    
    static let shared = PurchasesDelegateHandler()
}

extension PurchasesDelegateHandler: PurchasesDelegate {
    func purchases(_ purchases: Purchases, didReceiveUpdated purchaserInfo: Purchases.PurchaserInfo) {
        UserHandling.shared.userInfo = purchaserInfo
    }
}
