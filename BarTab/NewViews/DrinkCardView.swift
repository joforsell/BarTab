//
//  DrinkCardView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-02.
//

import SwiftUI

struct DrinkCardView: View {
    var drinkVM: DrinkViewModel
    var orderNamespace: Namespace.ID
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomTrailing) {
                Image("beer")
                    .resizable()
                    .foregroundColor(.accentColor)
                    .matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) image", in: orderNamespace)
                VStack {
                    Text(drinkVM.drink.name).font(.title).bold()
                        .matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) drinkName", in: orderNamespace)
                    Text("\(drinkVM.drink.price) kr")
                        .matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) drinkPrice", in: orderNamespace)
                }
                .foregroundColor(.white)
            }
            .background(Color("AppBlue").matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) view", in: orderNamespace))
            .frame(width: geo.size.width, height: 250)
        }
    }
}
