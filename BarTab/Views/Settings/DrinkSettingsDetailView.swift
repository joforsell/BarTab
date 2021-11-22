//
//  DrinkSettingsDetailView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-11-15.
//

import SwiftUI

struct DrinkSettingsDetailView: View {
    @Binding var drinkVM: DrinkViewModel
    
    @State private var editingName = false
    @State private var editingPrice = false
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Namn:")
                        .frame(width: 400, alignment: .leading)
                        .offset(y: 10)
                    HStack(alignment: .center) {
                        TextField(drinkVM.drink.name,
                                  text: $drinkVM.drink.name,
                                  onEditingChanged: { (editingChanged) in
                            if editingChanged {
                                editingName = true
                            } else {
                                editingName = false
                            } },
                                  onCommit: { editingName.toggle() }
                        )
                            .frame(width: 300, alignment: .leading)
                            .font(.largeTitle)
                        Spacer()
                    }
                    .frame(width: 400)
                    .padding()
                    .foregroundColor(.primary)
                    .addBorder(editingName ? .accentColor : Color("AppBlue"), width: 2, cornerRadius: 20)
                }
                VStack {
                    Text("Pris:")
                        .frame(width: 100, alignment: .leading)
                        .offset(y: 10)
                    HStack(alignment: .center) {
                        Text("\(drinkVM.drink.price) kr")
                            .frame(width: 80, alignment: .leading)
                            .font(.largeTitle)
                            .sheet(isPresented: $editingPrice) {
                                DrinkNumberPad(drink: drinkVM.drink)
                                    .clearModalBackground()
                            }
                        Spacer()
                    }
                    .frame(width: 100)
                    .padding()
                    .foregroundColor(.primary)
                    .addBorder(editingPrice ? .accentColor : Color("AppBlue"), width: 2, cornerRadius: 20)
                    .onTapGesture {
                        editingPrice = true
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        Spacer()
    }
}

struct DrinkSettingsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DrinkSettingsDetailView(drinkVM: .constant(DrinkViewModel(drink: Drink(name: "Öl", price: 40))))
            .previewLayout(.sizeThatFits)
    }
}
