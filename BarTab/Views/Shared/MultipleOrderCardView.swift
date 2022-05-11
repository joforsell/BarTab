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
    
    @Binding var orderList: [DrinkViewModel]
    
    var drinkVM: DrinkViewModel

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                Image(drinkVM.drink.image.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .minimumScaleFactor(0.2)
                    .foregroundColor(.accentColor.opacity(0.3))
                    .frame(maxHeight: geo.size.height * 0.9, alignment: .center)
                    .padding()
                VStack(alignment: .leading) {
                    Spacer()
                    Text(drinkVM.drink.name)
                        .font(.caption2)
                        .fixedSize()
                        .minimumScaleFactor(0.1)

                    Text(Currency.display(drinkVM.drink.price, with: userHandler.user))
                        .bold()
                        .fixedSize()
                        .minimumScaleFactor(0.1)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .padding(4)
                .overlay(alignment: .topTrailing) {
                    Button {
                        withAnimation {
                            orderList.removeAll(where: { $0.id == drinkVM.id })
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body)
                            .foregroundColor(.white)
                            .padding(8)
                    }
                }
            }
            .background(VisualEffectBlurView(blurStyle: .dark))
            .frame(width: 80, height: 100, alignment: .leading)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .addBorder(Color.accentColor.opacity(0.8), width: 1, cornerRadius: 10)
        }

    }
}
