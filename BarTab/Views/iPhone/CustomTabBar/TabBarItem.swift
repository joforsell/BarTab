//
//  TabBarItem.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-03-05.
//

import Foundation
import SwiftUI

enum TabBarItem: CaseIterable {
    case drinks, customers, settings
    
    var icon: Image {
        switch self {
        case .drinks:
            return Image("beer")
        case .customers:
            return Image(systemName: "person.2")
        case .settings:
            return Image(systemName: "gear")
        }
    }
}
