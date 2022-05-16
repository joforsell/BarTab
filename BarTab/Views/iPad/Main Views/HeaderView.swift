//
//  HeaderView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-29.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var confirmationVM: ConfirmationViewModel
    @EnvironmentObject var userHandler: UserHandling
    
    @Binding var viewState: ViewState
    @Binding var orderList: [OrderViewModel]
    @Binding var orderMultiple: Bool
    @Binding var tappedDrink: String?
    var orderNamespace: Namespace.ID
    var sum: String {
        let drinkPrices = orderList.map { $0.drink.price }
        let sum = drinkPrices.reduce(into: 0) { $0 += $1 }
        return Currency.display(Float(sum), with: userHandler.user)
    }
    
    var body: some View {
        HStack {
            Image("logo_yellow")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
                .padding()
            Spacer()
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            orderMultiple.toggle()
                            orderList.removeAll()
                        }
                    } label: {
                        Image(systemName: orderMultiple ? "rectangle.stack.fill.badge.plus" : "rectangle.stack.badge.plus")
                            .font(.system(size: 44))
                            .opacity(orderMultiple ? 1 : 0.4)
                            .foregroundColor(.accentColor)
                            .padding()
                    }
                    .onChange(of: orderList.count) { _ in
                        if orderList.isEmpty {
                            withAnimation {
                                orderMultiple = false
                            }
                        }
                    }
                    Image(systemName: "gear")
                        .font(.system(size: 60))
                        .foregroundColor(viewState == .settings ? .black : .accentColor)
                        .background(viewState == .settings ? Color.accentColor.cornerRadius(6) : Color.clear.cornerRadius(6))
                        .rotationEffect(.degrees(viewState == .main ? 0 : 180))
                        .padding()
                        .onTapGesture {
                            withAnimation {
                                if viewState == .main {
                                    confirmationVM.isShowingConfirmationView = false
                                    viewState = .settings
                                } else {
                                    viewState = .main
                                }
                            }
                        }
                }
                Spacer()
            }
        }
        .background(Color.black.opacity(0.6))
        .overlay(alignment: .center) {
            if orderMultiple && !orderList.isEmpty {
                Button {
                    withAnimation {
                        tappedDrink = "multiple"
                        confirmationVM.selectedDrink = nil
                    }
                } label: {
                    Text("Order items for \(sum)")
                        .font(.title3)
                        .padding()
                        .addBorder(Color.accentColor, cornerRadius: 10)
                }
                .matchedGeometryEffect(id: "multiple", in: orderNamespace, isSource: true)
                .disabled(orderList.isEmpty)
            } else {
                Text(userHandler.user.association ?? "")
                    .foregroundColor(.gray)
                    .font(.system(size: 40))
            }
        }
    }
}
