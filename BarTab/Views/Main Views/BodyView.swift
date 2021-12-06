//
//  BodyView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-30.
//

import SwiftUI

struct BodyView: View {
    @Binding var viewState: ViewState
    
    var orderNamespace: Namespace.ID
    
    var body: some View {
        Group {
            switch viewState {
            case .main:
                HStack {
                    OrderView(orderNamespace: orderNamespace)
                    CustomerListView()
                }
            case .settings:
                SettingsView()
                    .frame(width: UIScreen.main.bounds.width)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}
