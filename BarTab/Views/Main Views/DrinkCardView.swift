//
//  DrinkCardView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-02.
//

import SwiftUI
import SwiftUIX

struct DrinkCardView: View {
    var drinkVM: DrinkViewModel
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomTrailing) {
                Image(drinkVM.drink.image.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.accentColor.opacity(0.3))
                    .frame(maxHeight: geo.size.height * 0.4)
                    .padding()
                VStack(alignment: .leading) {
                    Text(drinkVM.drink.name).font(.title3).bold()
                    Text("\(drinkVM.drink.price) kr")
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .padding()
            }
            .background(VisualEffectBlurView(blurStyle: .dark))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .addBorder(Color.white.opacity(0.1), width: 1, cornerRadius: 10)
        }
    }
}
