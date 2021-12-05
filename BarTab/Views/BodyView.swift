//
//  BodyView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-30.
//

import SwiftUI

struct BodyView: View {
    var orderNamespace: Namespace.ID
    
    var body: some View {
        HStack {
            OrderView(orderNamespace: orderNamespace)
            CustomerListView()
        }
    }
}
