//
//  MultiSelectionPickerView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-04-25.
//

import SwiftUI

struct MultiSelectionPickerView: View {
    @Binding var items: [PaymentSelection]
    
    var body: some View {
        ForEach(items.indices) { index in
            Button {
                withAnimation {
                    items[index].active.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: "checkmark")
                        .opacity(items[index].active ? 1 : 0)
                        .foregroundColor(.accentColor)
                    Text(makeLocalizedStringKey(for: items[index].method))
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private func makeLocalizedStringKey(for method: PaymentMethod) -> LocalizedStringKey {
        switch method {
        case .swish:
            return LocalizedStringKey("Swish")
        case .bankAccount:
            return LocalizedStringKey("Bank Account")
        case .plusgiro:
            return LocalizedStringKey("Plusgiro")
        case .venmo:
            return LocalizedStringKey("Venmo")
        case .paypal:
            return LocalizedStringKey("PayPal")
        case .cashApp:
            return LocalizedStringKey("Cash App")
        }
    }
}
