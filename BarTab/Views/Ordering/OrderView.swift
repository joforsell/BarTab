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
    @EnvironmentObject var userVM: CustomerViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var tagKey = ""
    @State private var showToast = false
    var drink: Drink
    
    var body: some View {
        ZStack {
            TextField("Läs av tag", text: $tagKey, onCommit: {
                userVM.drinkBought(by: tagKey, for: drink.price)
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    presentationMode.wrappedValue.dismiss()
                }
            })
                .introspectTextField { textField in
                    textField.becomeFirstResponder()
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                .background(Color.black.opacity(0.4))
            VStack {
                Image(systemName: "sensor.tag.radiowaves.forward")
                    .font(.system(size: 300))
                Text("Vill du köpa \(drink.name) för \(drink.price) kr?")
                    .foregroundColor(.white)
                    .padding()
            }
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
        .toast(isPresented: $showToast, dismissAfter: 2) {
            CheckmarkView(height: 60, width: 60, drink: drink)
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView(drink: Drink(name: "Öl", price: 20))
    }
}
