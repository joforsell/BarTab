//
//  DrinkNumberPad.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-18.
//

import SwiftUI

struct DrinkNumberPad: View {
    @EnvironmentObject var drinkListVM: DrinkListViewModel
    @ObservedObject var numPadVM = NumberPadViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    let drink: Drink
        
    var body: some View {
        VStack {
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
                                drinkListVM.adjustPriceOf(drink: drink, to: Int(numPadVM.amount) ?? 0)
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

struct NumberPad_Previews: PreviewProvider {
    static var previews: some View {
        CustomerNumberPad(customer: Customer(name: "John", balance: 900, email: "john@john.com"))
            .previewLayout(.sizeThatFits)
    }
}
