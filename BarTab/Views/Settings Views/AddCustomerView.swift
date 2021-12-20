//
//  AddCustomerView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-05.
//

import SwiftUI
import SwiftUIX

struct AddCustomerView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var email = ""
    @State private var balance = ""
    
    @State private var editingName = false
    @State private var editingEmail = false
    @State private var editingBalance = false
    
    @State private var isShowingAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                
                Image(systemName: "person.crop.circle.badge.plus")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 240, weight: .thin))
                    .padding(.bottom, 48)
                
                CustomInputView(title: "Namn", image: "person.text.rectangle.fill", editing: $editingName, text: $name)
                
                CustomInputView(title: "Mailadress", image: "envelope.fill", editing: $editingEmail, text: $email)
                
                CustomInputView(title: "Ingående saldo", image: "dollarsign.square.fill", editing: $editingBalance, text: $balance)
                
                Color.clear
                    .frame(width: 300, height: 16)
                    .padding()
                    .overlay {
                        Button {
                            if name.trimmingCharacters(in: .whitespaces).isEmpty {
                                isShowingAlert = true
                            } else {
                                customerListVM.addCustomer(name: name, balance: Int(balance) ?? 0, email: email)
                                presentationMode.wrappedValue.dismiss()
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 6)
                                .overlay {
                                    Text("Skapa användare".uppercased())
                                        .foregroundColor(.white)
                                }
                        }
                    }
                .alert(isPresented: $isShowingAlert) {
                    Alert(title: Text("Användaren måste ha ett namn"), dismissButton: .default(Text("OK").foregroundColor(.accentColor)))
                }
                Spacer()
            }
            .center(.horizontal)
        }
        .background(VisualEffectBlurView(blurStyle: .dark))
    }
}
