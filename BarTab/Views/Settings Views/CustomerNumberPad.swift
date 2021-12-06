//
//  CustomerNumberPad.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI

struct CustomerNumberPad: View {
    @EnvironmentObject var customerVM: CustomerListViewModel
    @ObservedObject var numPadVM = NumberPadViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    let customer: Customer
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    withAnimation {
                        numPadVM.adding = true
                    }
                } label: {
                    Text("+")
                }
                .padding(.horizontal, 30)
                .background(Color.green.opacity(numPadVM.adding ? 0.8 : 0.1))
                .cornerRadius(30)
                .padding(.top)

                Spacer()
                
                Button {
                    withAnimation {
                        numPadVM.adding = false
                    }
                } label: {
                    Text("-")
                }
                .padding(.horizontal, 30)
                .background(Color.red.opacity(numPadVM.adding ? 0.1 : 0.8))
                .cornerRadius(30)
                .padding(.top)

                Spacer()

            }
            amountView
            ForEach(numPadVM.buttons, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { button in
                        if button == "back" {
                            Button {
                                numPadVM.eraseNum()
                            } label: {
                                Image(systemName: "delete.left.fill")
                                    .font(.system(size: 40, weight: .bold))
                                    .fixedSize()
                                    .frame(width: 70)
                            }
                            
                        } else if button == "enter" {
                            Button {
                                if numPadVM.adding {
                                    customerVM.addToBalance(of: customer, by: Int(numPadVM.amount) ?? 0)
                                } else {
                                    customerVM.subtractFromBalance(of: customer, by: Int(numPadVM.amount) ?? 0)
                                }
                                numPadVM.amount = "0"
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "checkmark.square.fill")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(Color("AppYellow"))
                                    .fixedSize()
                                    .frame(width: 70)
                            }

                        } else {
                            Button {
                                numPadVM.addNumValue(of: button)
                            } label: {
                                Text(button)
                            }
                                .padding()
                                .fixedSize()
                                .frame(width: 70)
                        }
                    }
                }
            }
        }
        .foregroundColor(.white)
        .font(.system(size: 30, weight: .bold))
        .background(Color("AppBlue"))
        .frame(width: 280)
        .cornerRadius(20)
    }
    
    @ViewBuilder var amountView: some View {
        if numPadVM.adding {
            Text("\(numPadVM.amount)" + " kr")
                .foregroundColor(Color("AppBlue"))
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(numPadVM.adding ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                .background(Color.white)
                .cornerRadius(30)
                .padding(.top)
                .padding(.horizontal)
        } else {
            Text("-\(numPadVM.amount)" + " kr")
                .foregroundColor(Color("AppBlue"))
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(numPadVM.adding ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                .background(Color.white)
                .cornerRadius(30)
                .padding(.top)
                .padding(.horizontal)

        }
    }
}

struct CustomerNumberPad_Previews: PreviewProvider {
    static var previews: some View {
        CustomerNumberPad(customer: Customer(name: "John", balance: 900, email: "john@john.com"))
            .previewLayout(.sizeThatFits)
    }
}

