//
//  InputView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI

struct InputView: View {
    @EnvironmentObject var userStore: CustomerViewModel
    @EnvironmentObject var drinkStore: DrinkViewModel
    
    @State private var isShowingOrderView = false
    @State private var selectedDrink: Drink? = nil
    
    private var rows = [GridItem(.adaptive(minimum: 100)), GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    ForEach(drinkStore.drinks.prefix(3)) { drink in
                        Button(action: {
                            selectedDrink = drink
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
                            .frame(width: UIScreen.main.bounds.width / 3.15, height: UIScreen.main.bounds.height / 3, alignment: .center)
                        }
                        .background(Color("AppBlue"))
                        .cornerRadius(15)
                        .foregroundColor(.white)
                    }
                    .padding(.top)
                    Spacer()
                }
                if drinkStore.drinks.count > 3 {
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: rows, spacing: 5) {
                            ForEach(gridViewDrinkList) { drink in
                                
                                Button(action: {
                                    selectedDrink = drink
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
                                .background(Color("AppBlue"))
                                .cornerRadius(15)
                                .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2)
                    }
                    .padding(.horizontal)
                }
                Spacer()
                    .sheet(isPresented: $isShowingOrderView) {
                        OrderView(drink: selectedDrink!)
                            .environmentObject(userStore)
                            .environmentObject(drinkStore)
                }
            }
        }
        .blur(radius: isShowingOrderView ? 8 : 0)
    }
    
    var gridViewDrinkList: [Drink] {
        return drinkStore.drinks.suffix(drinkStore.drinks.count - 3)
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            InputView()
                .environmentObject(CustomerViewModel())
                .environmentObject(DrinkViewModel())
                .previewInterfaceOrientation(.landscapeRight)
        } else {
            InputView()
                .environmentObject(CustomerViewModel())
                .environmentObject(DrinkViewModel())
        }
    }
}
