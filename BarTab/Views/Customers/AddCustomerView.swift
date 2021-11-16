//
//  AddCustomerView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-26.
//

import SwiftUI
import Introspect

struct AddCustomerView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.presentationMode) var presentationMode
    
    enum Field {
        case name, balance, tag
    }
    
    @State private var name = ""
    @State private var email = ""
    @State private var balance = ""
    @State private var tagKey = ""
    @State private var isShowingTagView = false
    
    
    var body: some View {
        ZStack {
            if !isShowingTagView {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .padding()
                            .onTapGesture { presentationMode.wrappedValue.dismiss() }
                            .zIndex(2)
                    }
                    Spacer()
                }
            }
            VStack {
                HStack {
                    Image(systemName: "person.fill.badge.plus")
                        .font(.largeTitle)
                    Text("Lägg till medlem")
                        .font(.largeTitle)
                }

                TextField("Namn", text: $name)
                    .disableAutocorrection(true)
                    .frame(width: UIScreen.main.bounds.width / 3, alignment: .center)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black))
                    .padding()
                TextField("Mailadress", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .frame(width: UIScreen.main.bounds.width / 3, alignment: .center)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black))
                    .padding()
                TextField("Saldo", text: $balance)
                    .keyboardType(.numberPad)
                    .frame(width: UIScreen.main.bounds.width / 3, alignment: .center)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black))
                    .keyboardType(.numberPad)

                    Button(action: {
                        if settingsManager.settings.usingTag {
                            isShowingTagView = true
                        } else {
                            customerListVM.addCustomerWithoutKey(name: self.name, balance: Int(self.balance) ?? 0, email: self.email)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Lägg till")
                            .frame(width: UIScreen.main.bounds.width / 3, alignment: .center)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
            }
            .blur(radius: isShowingTagView ? 8 : 0)
            if isShowingTagView {
                ZStack {
                    TextField("Läs av tag", text: $tagKey, onCommit: {
                        customerListVM.addCustomer(name: self.name, balance: Int(self.balance) ?? 0, key: self.tagKey, email: self.email)
                        presentationMode.wrappedValue.dismiss()
                    })
                        .introspectTextField { textField in
                            textField.becomeFirstResponder()
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                        .background(Color.black.opacity(0.4))
                    Image(systemName: "sensor.tag.radiowaves.forward")
                        .font(.system(size: 300))
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 30))
                                .foregroundColor(.black)
                                .padding(EdgeInsets(top: UIScreen.main.bounds.height / 12, leading: 0, bottom: 0, trailing: UIScreen.main.bounds.width / 6))
                                .onTapGesture { presentationMode.wrappedValue.dismiss() }
                                .zIndex(2)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct AddCustomerView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            AddCustomerView()
                .environmentObject(CustomerListViewModel())
                .previewInterfaceOrientation(.landscapeRight)
        } else {
            AddCustomerView()
                .environmentObject(CustomerListViewModel())
        }
    }
}
