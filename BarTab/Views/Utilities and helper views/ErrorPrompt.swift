//
//  ErrorPrompt.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-03-21.
//

import SwiftUI

struct ErrorPrompt: Identifiable {
    let id = UUID()
    let title: LocalizedStringKey
    let message: LocalizedStringKey
}
