//
//  AddCustomerView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-05.
//

import SwiftUI
import SwiftUIX

struct AddCustomerView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var avoider: KeyboardAvoider
    
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
                
                KeyboardAvoiding(with: avoider) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor)
                        .font(.system(size: 240, weight: .thin))
                        .padding(.bottom, 48)
                        .frame(maxWidth: geometry.size.width/2, maxHeight: geometry.size.height/2)
                
                    CustomInputView(title: "Name", image: "person.text.rectangle.fill", editing: $editingName, text: $name, keyboardTag: 7)
                    
                    CustomInputView(title: "E-mail address", image: "envelope.fill", editing: $editingEmail, text: $email, keyboardTag: 8)
                    
                    CustomInputView(title: "Opening balance", image: "dollarsign.square.fill", editing: $editingBalance, text: $balance, keyboardTag: 9)
                }
                
                Color.clear
                    .frame(width: 300, height: 16)
                    .padding()
                    .overlay {
                        Button {
                            if name.trimmingCharacters(in: .whitespaces).isEmpty {
                                isShowingAlert = true
                            } else {
                                let fixedCommasBalance = balance.replacingOccurrences(of: ",", with: ".")
                                let calculatedBalance = (Float(fixedCommasBalance) ?? 0) * 100
                                let balanceAsInt = Int(calculatedBalance)
                                customerListVM.addCustomer(name: name, balance: balanceAsInt, email: email)
                                presentationMode.wrappedValue.dismiss()
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 6)
                                .overlay {
                                    Text("Create bar guest")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .textCase(.uppercase)
                                }
                        }
                    }
                .alert(isPresented: $isShowingAlert) {
                    Alert(title: Text("The bar guest needs a name"), dismissButton: .default(Text("OK")))
                }
                Spacer()
            }
            .center(.horizontal)
        }
        .background(VisualEffectBlurView(blurStyle: .dark))
    }
}
