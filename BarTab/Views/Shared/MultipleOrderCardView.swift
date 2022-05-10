//
//  MultipleOrderCardView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-10.
//

import SwiftUI
import SwiftUIX

struct MultipleOrderCardView: View {
    @EnvironmentObject var userHandler: UserHandling
    var drinkVM: DrinkViewModel

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                Image(drinkVM.drink.image.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.accentColor.opacity(0.3))
                    .frame(maxHeight: geo.size.height * 0.8)
                    .padding()
                VStack(alignment: .leading) {
                    Text(drinkVM.drink.name)
                        .font(.caption2)
                        .fixedSize()
                        .minimumScaleFactor(0.4)

                    Text(Currency.display(drinkVM.drink.price, with: userHandler.user))
                        .font(.title)
                        .bold()
                        .fixedSize()
                        .minimumScaleFactor(0.4)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .padding()
            }
            .background(VisualEffectBlurView(blurStyle: .dark))
            .frame(width: 100, height: 140, alignment: .leading)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .addBorder(Color.white.opacity(0.1), width: 1, cornerRadius: 10)
        }

    }
}
