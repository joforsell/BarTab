//
//  SettingsState.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-24.
//

import Foundation

class SettingsState: ObservableObject {
    @Published var settingsTab: SettingsTab = .bartender
}
