//
//  View+ConditionalModifier.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-03-29.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
