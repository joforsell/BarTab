//
//  SettingsManager.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-01.
//

import Foundation

class SettingsManager: ObservableObject {
    
    @Published var settings = Settings() {
        didSet {
            if let encoded = try? JSONEncoder().encode(settings) {
                UserDefaults.standard.set(encoded, forKey: "settings")
            }
        }
    }
    
    init() {
        decodeFromUserDefaults()
    }
        
    func decodeFromUserDefaults() {
        if let userSettings = UserDefaults.standard.object(forKey: "settings") as? Data {
            let decoder = JSONDecoder()
            if let loadedSettings = try? decoder.decode(Settings.self, from: userSettings) {
                self.settings = loadedSettings
            }
        }
    }
}
