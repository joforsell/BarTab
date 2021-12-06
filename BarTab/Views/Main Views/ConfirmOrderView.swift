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
                Text(drinkVM.drink.name).font(.system(size: 80, weight: .black))
                    .matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) drinkName", in: orderNamespace)
                Text("\(drinkVM.drink.price) kr").font(.system(size: 40))
                    .matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) drinkPrice", in: orderNamespace)
                Spacer()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(40)
            Image("beer")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.2)
                .foregroundColor(.accentColor.opacity(0.3))
                .padding(20)
                .matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) image", in: orderNamespace)
        }
        .background(Color("AppBlue").matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) view", in: orderNamespace))
        .cornerRadius(20)
    }
}
