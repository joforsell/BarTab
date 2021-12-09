//
//  ConfirmOrderView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-02.
//

import SwiftUI
import Introspect
import ToastUI

struct ConfirmOrderView: View {
    @EnvironmentObject var customerListVM: CustomerListViewModel
    @EnvironmentObject var confirmationVM: ConfirmationViewModel
    
    var drinkVM: DrinkViewModel
    var orderNamespace: Namespace.ID
    
    @State private var tagKey = ""
    @State private var isShowingPurchaseConfirmedToast = false
    
    var body: some View {
        ZStack {
            TextField("Läs av bricka", text: $tagKey, onCommit: {
                customerListVM.customerBoughtWithKey(drinkVM.drink, key: tagKey)
                withAnimation {
                    isShowingPurchaseConfirmedToast = true
                }
            })
                .opacity(0)
            VStack(alignment: .leading) {
                Text(drinkVM.drink.name).font(.system(size: 80, weight: .black))
                    .matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) drinkName", in: orderNamespace)
                Text("\(drinkVM.drink.price) kr").font(.system(size: 40))
                    .matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) drinkPrice", in: orderNamespace)
                Spacer()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(40)
            VStack {
                Image(systemName: "wave.3.right.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.accentColor)
                    .padding()
                Text("Läs av din bricka för att slutföra köpet.")
                    .font(.title)
                    .foregroundColor(.white)
            }
            VStack(alignment: .trailing) {
                Spacer()
                HStack {
                    Spacer()
                    Image("beer")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width * 0.2)
                        .foregroundColor(.accentColor.opacity(0.3))
                        .padding(20)
                        .matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) image", in: orderNamespace)
                }
            }
        }
        .toast(isPresented: $isShowingPurchaseConfirmedToast, dismissAfter: 3, onDismiss: {
            withAnimation {
                confirmationVM.isShowingConfirmationView = false
            } }) {
            ToastView(systemImage: ("checkmark.circle.fill", .accentColor, 50), title: "Ditt köp slutfördes", subTitle: "\(customerListVM.customerWithKey(tagKey)) köpte \(confirmationVM.selectedDrink?.drink.name ?? "Saknas") för \(confirmationVM.selectedDrink?.drink.price ?? 0) kr.")
        }
        .background(Color("AppBlue").matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) view", in: orderNamespace))
        .cornerRadius(20)
        .introspectTextField { textField in
            textField.becomeFirstResponder()
        }
    }
}
