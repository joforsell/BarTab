//
//  InputView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-23.
//

import SwiftUI

struct InputView: View {
    @EnvironmentObject var userStore: UserViewModel
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
                        .background(Color.blue)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                    }
                    .padding(.top)
                    Spacer()
                }
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
                            .background(Color.blue)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                }
                .padding(.horizontal)
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
        if drinkStore.drinks.count > 3 {
            return drinkStore.drinks.suffix(drinkStore.drinks.count - 3)
        } else {
            return [Drink(name: "Placeholder", price: 0)]
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            InputView()
                .environmentObject(UserViewModel())
                .environmentObject(DrinkViewModel())
                .previewInterfaceOrientation(.landscapeRight)
        } else {
            InputView()
                .environmentObject(UserViewModel())
                .environmentObject(DrinkViewModel())
        }
    }
}
