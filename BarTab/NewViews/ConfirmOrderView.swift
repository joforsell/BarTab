//
//  ConfirmOrderView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-02.
//

import SwiftUI

struct ConfirmOrderView: View {
    var drinkVM: DrinkViewModel
    var orderNamespace: Namespace.ID
    
    @Binding var showConfirmationView: Bool
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                Text(drinkVM.drink.name).font(.title).bold()
                    .matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) drinkName", in: orderNamespace)
                Text("\(drinkVM.drink.price) kr")
                    .matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) drinkPrice", in: orderNamespace)
                Spacer()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Image("beer")
                .resizable()
                .frame(width: 200, height: 250)
                .foregroundColor(.accentColor)
                .matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) image", in: orderNamespace)
        }
        .background(Color("AppBlue").matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) view", in: orderNamespace))
        .frame(width: 600, height: 600)

    }
}
