//
//  AddCustomerView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-05.
//

import SwiftUI

struct AddCustomerView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var email = ""
    @State private var balance = ""
    
    @State private var isShowingAlert = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Image(systemName: "person.crop.circle.badge.plus")
                .foregroundColor(.accentColor)
                .font(.system(size: 240, weight: .thin))
            Spacer()
            Group {
                TextField("Namn", text: $name)
                    .disableAutocorrection(true)
                Rectangle()
                    .background(Color("AppBlue"))
                    .frame(height: 1)
                    .padding(.bottom)
                TextField("E-postadress", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                Rectangle()
                    .background(Color("AppBlue"))
                    .frame(height: 1)
                    .padding(.bottom)
                TextField("Ingående saldo", text: $balance)
                    .disableAutocorrection(true)
                    .keyboardType(.numberPad)
                Rectangle()
                    .background(Color("AppBlue"))
                    .frame(height: 1)
                    .padding(.bottom)
            }
            Button {
                if name.trimmingCharacters(in: .whitespaces).isEmpty {
                    isShowingAlert = true
                } else {
                    customerListVM.addCustomer(name: name, balance: Int(balance) ?? 0, email: email)
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 40)
                    .overlay(Text("OK").foregroundColor(.white))
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Användaren måste ha ett namn"), dismissButton: .default(Text("OK").foregroundColor(.accentColor)))
            }
            Spacer()
        }
        .padding(.horizontal, 160)
    }
}

struct AddCustomerView_Previews: PreviewProvider {
    static var previews: some View {
        AddCustomerView()
    }
}
