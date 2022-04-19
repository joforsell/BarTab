//
//  BalanceUpdateEmailView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-04-19.
//

import SwiftUI
import SwiftUIX

struct BalanceUpdateEmailView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @ObservedObject private var balanceUpdateEmailVM = BalanceUpdateEmailViewModel()
    
    @Binding var presenting: Bool
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(customerListVM.customerVMs) { customerVM in
                    Text(customerVM.customer.name)
                }
            }
            Button("Close") {
                presenting = false
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlurEffectView(style: .dark))
    }
}
