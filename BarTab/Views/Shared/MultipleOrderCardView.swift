//
//  MultipleOrderCardView.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-05-10.
//

import SwiftUI
import SwiftUIX

struct MultipleOrderCardView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @EnvironmentObject var userHandler: UserHandling
    
    @Binding var orderList: [OrderViewModel]
    
    var orderVM: OrderViewModel

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                Image(orderVM.drink.image.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .minimumScaleFactor(0.2)
                    .foregroundColor(.accentColor.opacity(0.3))
                    .frame(maxHeight: geo.size.height * 0.9, alignment: .center)
                    .padding()
                VStack(alignment: .leading) {
                    Spacer()
                    Text(orderVM.drink.name)
                        .font(isPhone() ? .caption2 : .title3)
                        .fixedSize()
                        .minimumScaleFactor(0.1)

                    Text(Currency.display(Float(orderVM.drink.price), with: userHandler.user))
                        .font(isPhone() ? .body : .title2)
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
                            orderList.removeAll(where: { $0.id == orderVM.id })
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
            .frame(width: isPhone() ? 80 : 120, height: isPhone() ? 100 : 150)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .addBorder(Color.accentColor.opacity(0.8), width: 1, cornerRadius: 10)
        }

    }
    
    private func isPhone() -> Bool {
        return !(horizontalSizeClass == .regular && verticalSizeClass == .regular)
    }
}
