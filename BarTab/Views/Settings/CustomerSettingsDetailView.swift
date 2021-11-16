//
//  CustomerSettingsDetailView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-15.
//

import SwiftUI

struct CustomerSettingsDetailView: View {
    @Binding var customerVM: CustomerViewModel
    
    @State private var editingName = false
    @State private var editingEmail = false
    @State private var editingBalance = false
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                if editingName {
                    TextField(customerVM.customer.name, text: $customerVM.customer.name, onCommit: { editingName.toggle() })
                } else {
                    Text(customerVM.customer.name)
                }
                EditCustomerButton(editing: $editingName)
                if editingEmail {
                    TextField(customerVM.customer.email, text: $customerVM.customer.email, onCommit: { editingEmail.toggle() })
                } else {
                    Text(customerVM.customer.email)
                }
                EditCustomerButton(editing: $editingEmail)
                Text("\(customerVM.customer.balance)")
                EditCustomerButton(editing: $editingBalance)
                    .sheet(isPresented: $editingBalance) {
                        NumberPad(customer: customerVM.customer)
                            .clearModalBackground()
                    }

            }
            Spacer()
            ForEach(customerVM.customer.drinksBought) { drink in
                Text(drink.name)
                Text("\(drink.price)")
            }
        }
    }
}

struct EditCustomerButton: View {
    @Binding var editing: Bool
    
    var body: some View {
        Button {
            editing.toggle()
        } label: {
            Image(systemName: "pencil")
        }
        .foregroundColor(.accentColor)
    }
}
