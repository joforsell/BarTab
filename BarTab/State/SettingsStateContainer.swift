//
//  SettingsStateContainer.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-24.
//

import Foundation

class SettingsStateContainer: ObservableObject {
    var settingsState = SettingsState()
    var detailViewState = DetailViewState()
}
