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
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.accentColor.opacity(0.3))
                    .frame(maxWidth: geo.size.width * 0.5)
                    .matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) image", in: orderNamespace, isSource: true)
                VStack(alignment: .leading) {
                    Text(drinkVM.drink.name).font(.title).bold()
                        .matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) drinkName", in: orderNamespace, isSource: true)
                    Text("\(drinkVM.drink.price) kr")
                        .matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) drinkPrice", in: orderNamespace, isSource: true)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .padding()
            }
            .background(Color("AppBlue"))
            .frame(width: geo.size.width, height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .matchedGeometryEffect(id: "\(drinkVM.drink.id ?? drinkVM.drink.name) view", in: orderNamespace, isSource: true)
        }
    }
}
