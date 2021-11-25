//
//  CustomerSettingsDetailView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-15.
//

import SwiftUI

struct CustomerSettingsDetailView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @Binding var customerVM: CustomerViewModel
    
    @State private var editingName = false
    @State private var editingEmail = false
    @State private var editingBalance = false
    @State private var isShowingKeyField = false
    @State private var newKey = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack {
                Text("Namn:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(y: 10)
                    .padding(.horizontal)
                HStack(alignment: .center) {
                    TextField(customerVM.customer.name,
                              text: $customerVM.customer.name,
                              onEditingChanged: { (editingChanged) in
                        if editingChanged {
                            editingName = true
                        } else {
                            editingName = false
                        } },
                              onCommit: { editingName.toggle() }
                    )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.largeTitle)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.primary)
                .addBorder(editingName ? .accentColor : Color("AppBlue"), width: 2, cornerRadius: 20)
                .padding(.horizontal)
            }
            
            VStack {
                Text("Email:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(y: 10)
                    .padding(.horizontal)
                HStack(alignment: .center) {
                    TextField(customerVM.customer.email,
                              text: $customerVM.customer.email,
                              onEditingChanged: { (editingChanged) in
                        if editingChanged {
                            editingEmail = true
                        } else {
                            editingEmail = false
                        } },
                              onCommit: { editingEmail.toggle() }
                    )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.largeTitle)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.primary)
                .addBorder(editingEmail ? .accentColor : Color("AppBlue"), width: 2, cornerRadius: 20)
                .padding(.horizontal)
            }
            
            VStack {
                Text("Pris:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(y: 10)
                    .padding(.horizontal)
                HStack(alignment: .center) {
                    Text("\(customerVM.customer.balance) kr")
                        .frame(idealWidth: 140, alignment: .leading)
                        .font(.largeTitle)
                        .sheet(isPresented: $editingBalance) {
                            CustomerNumberPad(customer: customerVM.customer)
                                .clearModalBackground()
                        }
                    Spacer()
                }
                .frame(idealWidth: 160)
                .padding()
                .foregroundColor(.primary)
                .addBorder(editingBalance ? .accentColor : Color("AppBlue"), width: 2, cornerRadius: 20)
                .onTapGesture {
                    editingBalance = true
                }
                .padding(.horizontal)
            }
            
            HStack {
                Button {
                    isShowingKeyField.toggle()
                } label: {
                    Image(systemName: "sensor.tag.radiowaves.forward.fill")
                        .font(.largeTitle)
                }
                
                if isShowingKeyField {
                    TextField("New key", text: $newKey, onCommit: {
                        customerListVM.updateKey(of: customerVM.customer, with: newKey)
                        newKey = ""
                        isShowingKeyField = false
                    })
                }
            }
            .padding()
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity)
    }
}
