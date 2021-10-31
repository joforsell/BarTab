//
//  OrderView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-26.
//

import SwiftUI
import Introspect
import ToastUI

struct OrderView: View {
    @EnvironmentObject var customerVM: CustomerViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var tagKey = ""
    @State private var showToast = false
    var drink: Drink
    
    var body: some View {
        ZStack {
            TextField("Läs av tag", text: $tagKey, onCommit: {
                customerVM.customerBought(drink, key: tagKey)
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    presentationMode.wrappedValue.dismiss()
                }
            })
                .opacity(0)
                .introspectTextField { textField in
                    textField.becomeFirstResponder()
                }
                    Image(systemName: "sensor.tag.radiowaves.forward")
                        .font(.system(size: 300))
                        .foregroundColor(Color.white)
                        .padding()
            HStack {
                VStack {
                    HStack {
                        Text("\(drink.name)")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                        Text("\(drink.price) kr")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                Spacer()
                VStack{
                    Menu {
                        ForEach(customerVM.customers) { customer in
                            Button("\(customer.name)") {
                                tagKey = customer.key
                                customerVM.customerBought(drink, key: tagKey)
                                showToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "person.2.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .padding()
                    }
                    Spacer()
                }
            }
        }
        .background(Color("AppYellow").ignoresSafeArea())
        .toast(isPresented: $showToast, dismissAfter: 2) {
            CheckmarkView(height: 60, width: 60, drink: drink)
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView(drink: Drink(name: "Öl", price: 20))
            .environmentObject(CustomerViewModel())
    }
}
