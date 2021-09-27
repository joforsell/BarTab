//
//  InputView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI

struct InputView: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var drinkStore: DrinkStore
    
    @State private var isShowingOrderView = false
    @State private var drinkPrice = 0
    
    private var rows = [GridItem(.adaptive(minimum: 100)), GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    ForEach(drinkStore.drinks.prefix(3)) { drink in
                        Button(action: {
                            drinkPrice = drink.price
                            isShowingOrderView = true
                        }) {
                            VStack {
                                Text(drink.name)
                                    .font(.system(size: 40))
                                    .fontWeight(.bold)
                                    .padding()
                                Text("\(drink.price) kr")
                                    .font(.system(size: 30))
                            }
                                .onTapGesture {
                                    drinkPrice = drink.price
                                    isShowingOrderView = true
                                }
                                .frame(width: UIScreen.main.bounds.width / 3.15, height: UIScreen.main.bounds.height / 3, alignment: .center)
                        }
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(15)
                        .foregroundColor(.black)
                    }
                    .padding(.top)
                    Spacer()
                }
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, spacing: 5) {
                        ForEach(drinkStore.drinks.suffix(drinkStore.drinks.count - 3)) { drink in
                            
                            Button(action: {
                                drinkPrice = drink.price
                                isShowingOrderView = true
                            }) {
                                VStack {
                                    Text(drink.name)
                                        .font(.system(size: 40))
                                        .fontWeight(.bold)
                                        .padding(.vertical, -15)
                                    Text("\(drink.price) kr")
                                        .font(.system(size: 30))
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width / 4.2, height: UIScreen.main.bounds.height / 4, alignment: .center)
                            .background(Color.white.opacity(0.6))
                            .cornerRadius(15)
                            .foregroundColor(.black)
                        }
                    }
                    .frame(width: .infinity, height: UIScreen.main.bounds.height / 2)
                }
                .padding(.horizontal)
                Spacer()
            }
            .sheet(isPresented: $isShowingOrderView) {
                OrderView(price: $drinkPrice)
                    .environmentObject(userStore)
        }
        }

    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            InputView()
                .environmentObject(UserStore())
                .environmentObject(DrinkStore())
                .previewInterfaceOrientation(.landscapeRight)
        } else {
            InputView()
                .environmentObject(UserStore())
                .environmentObject(DrinkStore())
        }
    }
}
