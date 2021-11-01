////
////  UserSettingsViewModel.swift
////  BarTab
////
////  Created by Johan Forsell on 2021-10-31.
////
//
//import SwiftUI
//import Combine
//
//class UserSettingsViewModel: ObservableObject {
//    @Published var settingsRepository = UserSettingsRepository()
//    @Published var settings = UserSettings()
//
//    var subscriptions = Set<AnyCancellable>()
//
//    init() {
//        settingsRepository.$settings
//            .assign(to: \.settings, on: self)
//            .store(in: &subscriptions)
//    }
//
//    func createSettings() {
//        let newSettings = UserSettings()
//        settingsRepository.addSettings(newSettings)
//    }
//}
