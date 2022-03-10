//
//  CustomerSettingsDetailsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI
import Combine
import Introspect

struct CustomerSettingsDetailView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var avoider: KeyboardAvoider
    @EnvironmentObject var userHandler: UserHandling
    
    @Binding var customerVM: CustomerViewModel
    @Binding var detailsViewShown: DetailViewRouter
    
    @State private var editingName = false
    @State private var editingEmail = false
    @State private var editingBalance = false
    
    @State private var isShowingKeyField = false
    @State private var newKey = ""
    @State private var balanceAdjustment = ""
    @State private var addingToBalance = true
    
    @State private var showError = false
    
    var body: some View {
            HStack {
                Spacer()
                VStack(alignment: .center, spacing: 16) {
                    Spacer()
                    
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(0.7)
                        .foregroundColor(.white)
                        .frame(maxHeight: 200)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        }
                    
                    // TODO: Add functionality to change profile picture
                    //                    .overlay(alignment: .bottomTrailing) {
                    //                        Button {
                    //
                    //                        } label: {
                    //                            Image(systemName: "pencil.circle.fill")
                    //                                .resizable()
                    //                                .scaledToFit()
                    //                                .frame(width: 22)
                    //                                .foregroundColor(.white)
                    //                        }
                    //                        .offset(x: 40)
                    //                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(alignment: .bottom) {
                            TextField("",
                                      text: $customerVM.name,
                                      onEditingChanged: { editingChanged in
                                self.avoider.editingField = 3
                                if editingChanged {
                                    editingName = true
                                } else {
                                    editingName = false
                                } },
                                      onCommit: { editingName.toggle() }
                            )
                                .disableAutocorrection(true)
                                .font(.title3)
                            Spacer()
                        }
                        .offset(y: 4)
                        .overlay(alignment: .trailing) {
                            Button {
                                UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
                            } label: {
                            Image(systemName: editingName ? "checkmark.rectangle.fill" : "person.text.rectangle.fill")
                                .resizable()
                                .scaledToFit()
                                .opacity(editingName ? 1 : 0.5)
                                .foregroundColor(editingName ? .accentColor : .white)
                            }
                            .disabled(!editingName)
                        }
                        .overlay(alignment: .topLeading) {
                            Text("Name")
                                .font(.caption2)
                                .textCase(.uppercase)
                                .foregroundColor(.white)
                                .opacity(0.5)
                                .offset(y: -10)
                        }
                    }
                    .frame(width: 300, height: 24)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(6)
                    .addBorder(editingName ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
                    .padding(.top, 24)
                    .avoidKeyboard(tag: 3)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(alignment: .bottom) {
                            TextField("",
                                      text: $customerVM.email,
                                      onEditingChanged: { editingChanged in
                                self.avoider.editingField = 4
                                if editingChanged {
                                    editingEmail = true
                                } else {
                                    editingEmail = false
                                } },
                                      onCommit: { editingEmail.toggle() }
                            )
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .font(.title3)
                                .padding(.trailing)
                            Spacer()
                        }
                        .offset(y: 4)
                        .overlay(alignment: .trailing) {
                            Button {
                                UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
                            } label: {
                                Image(systemName: editingEmail ? "checkmark.rectangle.fill" : "envelope.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(editingEmail ? 1 : 0.5)
                                    .foregroundColor(editingEmail ? .accentColor : .white)
                            }
                            .disabled(!editingEmail)
                        }
                        .overlay(alignment: .topLeading) {
                            Text("E-mail address")
                                .font(.caption2)
                                .textCase(.uppercase)
                                .foregroundColor(.white)
                                .opacity(0.5)
                                .offset(y: -10)
                        }
                        
                    }
                    .frame(width: 300, height: 24)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(6)
                    .addBorder(editingEmail ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
                    .avoidKeyboard(tag: 4)
                    
                    // TODO: Find out why view will only update on first change.
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(alignment: .bottom) {
                            if editingBalance {
                                TextField("", text: $balanceAdjustment, onEditingChanged: { _ in
                                    self.avoider.editingField = 5
                                }, onCommit: {
                                    if addingToBalance {
                                        customerListVM.addToBalance(of: customerVM.customer, by: Int(balanceAdjustment) ?? 0)
                                        customerVM.customer.balance += Int(balanceAdjustment) ?? 0
                                    } else {
                                        customerListVM.subtractFromBalance(of: customerVM.customer, by: Int(balanceAdjustment) ?? 0)
                                        customerVM.customer.balance -= Int(balanceAdjustment) ?? 0
                                    }
                                    withAnimation {
                                        editingBalance = false
                                    }
                                    balanceAdjustment = ""
                                })
                                    .onChange(of: customerVM.customer.balance) { balance in
                                        customerVM.customer.balance = balance
                                    }
                                    .onReceive(Just(balanceAdjustment)) { newValue in
                                        let filtered = newValue.filter { "01233456789".contains($0) }
                                        if filtered != newValue {
                                            self.balanceAdjustment = filtered
                                        }
                                    }
                            } else {
                                Text("$\(customerVM.balanceAsString)")
                                    .font(.title3)
                                    .foregroundColor(customerVM.balanceColor)
                            }
                            Spacer()
                        }
                        .offset(y: 4)
                        .overlay(alignment: .trailing) {
                            Button {
                                UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
                                if addingToBalance {
                                    customerListVM.addToBalance(of: customerVM.customer, by: Int(balanceAdjustment) ?? 0)
                                    customerVM.customer.balance += Int(balanceAdjustment) ?? 0
                                } else {
                                    customerListVM.subtractFromBalance(of: customerVM.customer, by: Int(balanceAdjustment) ?? 0)
                                    customerVM.customer.balance -= Int(balanceAdjustment) ?? 0
                                }
                                withAnimation {
                                    editingBalance = false
                                }
                                balanceAdjustment = ""

                            } label: {
                                Image(systemName: editingBalance ? "checkmark.rectangle.fill" : "dollarsign.square.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(editingBalance ? 1 : 0.5)
                                    .foregroundColor(editingBalance ? .accentColor : .white)
                            }
                            .disabled(!editingBalance)
                        }
                        .overlay(alignment: .topLeading) {
                            if !editingBalance {
                                Text("Balance")
                                    .font(.caption2)
                                    .textCase(.uppercase)
                                    .foregroundColor(.white)
                                    .opacity(0.5)
                                    .offset(y: -10)
                            } else if editingBalance && addingToBalance {
                                Text("Add")
                                    .font(.caption2)
                                    .textCase(.uppercase)
                                    .foregroundColor(Color("Lead"))
                                    .opacity(0.5)
                                    .offset(y: -10)
                            } else {
                                Text("Subtract")
                                    .font(.caption2)
                                    .textCase(.uppercase)
                                    .foregroundColor(Color("Deficit"))
                                    .opacity(0.5)
                                    .offset(y: -10)
                            }
                        }
                    }
                    .frame(width: 300, height: 24)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(6)
                    .addBorder(editingBalance ? addingToBalance ? Color("Lead") : Color("Deficit") : Color.clear, width: 1, cornerRadius: 6)
                    .avoidKeyboard(tag: 5)

                    HStack(spacing: 4) {
                        Button {
                            withAnimation {
                                addingToBalance = true
                                editingBalance.toggle()
                            }
                        } label: {
                            Image(systemName: "plus.square.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("Lead"))
                                .frame(width: 40)
                        }
                        Spacer()
                        Button {
                            withAnimation {
                                addingToBalance = false
                                editingBalance.toggle()
                            }
                        } label: {
                            Image(systemName: "minus.square.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("Deficit"))
                                .frame(width: 40)
                        }
                    }
                    .frame(width: 300, height: 24)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                        }
                        .frame(width: 300, height: 24)
                        .padding()
                        .overlay(alignment: .leading) {
                            if userHandler.user.usingTags {
                                Button {
                                    isShowingKeyField.toggle()
                                } label: {
                                    Text("Uppdate \nRFID tag")
                                        .multilineTextAlignment(.leading)
                                        .fixedSize()
                                        .frame(width: 160, height: 24, alignment: .leading)
                                        .padding()
                                        .background(Color.accentColor)
                                        .cornerRadius(6)
                                        .contentShape(Rectangle())
                                }
                                .overlay(alignment: .trailing) {
                                    Image(systemName: "wave.3.right.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .padding()
                                }
                                .foregroundColor(.white)
                                .sheet(isPresented: $isShowingKeyField) {
                                    UpdateTagView(customer: customerVM.customer)
                                        .clearModalBackground()
                                }
                            }
                        }
                        .overlay(alignment: .trailing) {
                            Button {
                                showError.toggle()
                            } label: {
                                Image(systemName: "trash.square.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.red)
                            }
                            .alert(isPresented: $showError) {
                                Alert(title: Text("Delete bar guest"),
                                      message: Text("Are you sure you want to delete this bar guest?"),
                                      primaryButton: .default(Text("Cancel")),
                                      secondaryButton: .destructive(Text("Delete")) {
                                    customerListVM.removeCustomer(customerVM.customer)
                                    detailsViewShown = .none
                                })
                            }
                        }
                    }
                    .padding(.top, 48)
                    
                    Spacer()
                }
                Spacer()
            }
            .overlay(alignment: .topLeading) {
                if isPhone() {
                    Button {
                        withAnimation {
                            detailsViewShown = .none
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .padding()
                            .foregroundColor(.white)
                            .opacity(0.6)
                            .contentShape(Rectangle().size(width: 40, height: 40))
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    
    private func isPhone() -> Bool {
        return !(horizontalSizeClass == .regular && verticalSizeClass == .regular)
    }
}
