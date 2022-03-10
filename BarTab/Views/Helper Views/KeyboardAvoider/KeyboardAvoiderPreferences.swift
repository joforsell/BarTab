//
//  KeyboardAvoiderPreferences.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-01-06.
//

import SwiftUI

// MARK: - Keyboard Avoiding Field Preference
struct KeyboardAvoiderPreference: Equatable {
    
    let tag: Int
    let rect: CGRect
    
    static func == (lhs: KeyboardAvoiderPreference, rhs: KeyboardAvoiderPreference) -> Bool {
       return  lhs.tag == rhs.tag && (lhs.rect.minY == rhs.rect.minY)
    }
}

struct KeyboardAvoiderPreferenceKey: PreferenceKey {
    
    typealias Value = [KeyboardAvoiderPreference]
    
    static var defaultValue: [KeyboardAvoiderPreference] = []
    
    static func reduce(value: inout [KeyboardAvoiderPreference], nextValue: () -> [KeyboardAvoiderPreference]) {
         value.append(contentsOf: nextValue())
    }
}


struct KeyboardAvoiderPreferenceReader: ViewModifier {
    
    let tag: Int
    
    func body(content: Content) -> some View {
        
        content
            .background(
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.clear)
                        .preference(
                            key: KeyboardAvoiderPreferenceKey.self,
                            value: [
                                KeyboardAvoiderPreference(tag: self.tag, rect: geometry.frame(in: .global))
                        ])
                }
            )
    }
}

extension View {
    
    func avoidKeyboard(tag: Int) -> some View {
        self.modifier(KeyboardAvoiderPreferenceReader(tag: tag))
    }
    
}
