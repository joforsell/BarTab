//
//  CustomerSettingsDetailsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI
import Introspect

struct CustomerSettingsDetailView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @ObservedObject var customerRepository = CustomerRepository()
    
    @Binding var customerVM: CustomerViewModel
    var geometry: GeometryProxy
        
    @State private var editingName = false
    @State private var editingEmail = false
    @State private var editingBalance = false
    @State private var isShowingKeyField = false
    @State private var newKey = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 48) {
                VStack {
                    VStack {
                        Text("Namn:")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(y: 10)
                            .padding(.horizontal)
                            .foregroundColor(.white)
                        HStack(alignment: .center) {
                            TextField(customerVM.customer.name,
                                      text: $customerVM.customer.name,
                                      onEditingChanged: { editingChanged in
                                if editingChanged {
                                    editingName = true
                                } else {
                                    editingName = false
                                } },
                                      onCommit: {
                                editingName.toggle()
                                customerRepository.updateCustomer(customerVM.customer)
                            }
                            )
                                .disableAutocorrection(true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title2)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.primary)
//                        .background(textFieldBackground)
                        .addBorder(editingName ? .accentColor : Color.white.opacity(0.3), width: 2, cornerRadius: 10)
                        .padding(.horizontal)
                    }
                    
                    VStack {
                        Text("Email:")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(y: 10)
                            .padding(.horizontal)
                            .foregroundColor(.white)
                        HStack(alignment: .center) {
                            TextField(customerVM.customer.email,
                                      text: $customerVM.customer.email,
                                      onEditingChanged: { editingChanged in
                                if editingChanged {
                                    editingEmail = true
                                } else {
                                    editingEmail = false
                                } },
                                      onCommit: {
                                editingEmail.toggle()
                                customerRepository.updateCustomer(customerVM.customer)
                            }
                            )
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .keyboardType(.emailAddress)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title2)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.primary)
//                        .background(textFieldBackground)
                        .addBorder(editingEmail ? .accentColor : Color.white.opacity(0.3), width: 2, cornerRadius: 10)
                        .padding(.horizontal)
                    }
                    
//                    VStack {
//                        Text("Saldo:")
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .offset(y: 10)
//                            .padding(.horizontal)
//                            .foregroundColor(.white)
//                        HStack(alignment: .center) {
//                            Text("\(customerVM.customer.balance) kr")
//                                .frame(idealWidth: 140, alignment: .leading)
//                                .font(.title2)
//                                .sheet(isPresented: $editingBalance) {
//                                    CustomerNumberPad(customer: customerVM.customer)
//                                        .clearModalBackground()
//                                }
//                            Spacer()
//                        }
//                        .frame(idealWidth: 160)
//                        .padding()
//                        .foregroundColor(.primary)
////                        .background(textFieldBackground)
//                        .addBorder(editingBalance ? .accentColor : Color.white.opacity(0.3), width: 2, cornerRadius: 10)
//                        .onTapGesture {
//                            editingBalance = true
//                        }
//                        .padding(.horizontal)
//                    }
                }
                
                VStack {
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(0.7)
                        .foregroundColor(.white)
                        .frame(height: geometry.size.height * 0.3)
                        .background(Color("AppBlue"))
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        }
                        .overlay {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Image(systemName: "pencil.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.accentColor)
                                        .frame(width: 44, height: 44)
                                        .padding(4)
                                }
                            }
                        }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            isShowingKeyField.toggle()
                        } label: {
                            VStack {
                                Image(systemName: "sensor.tag.radiowaves.forward.fill")
                                .font(.system(size: 60))
                                Text("Uppdatera \nRFID-bricka")
                                    .font(.footnote)
                            }
                            .foregroundColor(.accentColor)
                        }
                        
                        if isShowingKeyField {
                            SecureField("New key", text: $newKey, onCommit: {
                                customerListVM.updateKey(of: customerVM.customer, with: newKey)
                                newKey = ""
                                isShowingKeyField = false
                            })
                                .introspectTextField { textField in
                                    textField.becomeFirstResponder()
                                }
                        }
                    }
                    .padding(.top, 48)
                }
                .frame(width: geometry.size.height * 0.3)
            }
            .padding()
            .background(Color.white.opacity(0.15))
            .cornerRadius(20)
                        
            Spacer()

            HStack {
                Spacer()
                Button {
                    customerListVM.removeCustomer(customerVM.customer.id ?? "")
                } label: {
                    VStack {
                        Image(systemName: "trash.fill")
                            .font(.largeTitle)
                        Text("Radera")
                    }
                    .foregroundColor(.red)
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(48)
    }
    
    var textFieldBackground: some View {
        Color.white.opacity(0.15)
    }
}
