//
//  DrinkSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-09-30.
//

import SwiftUI

struct DrinkSettingsView: View {
    @EnvironmentObject var drinkViewModel: DrinkViewModel
    
    @State private var showingAddDrinkView = false
    
    var body: some View {
        VStack {
            List(drinkViewModel.drinks) { drink in
                HStack {
                    Text(drink.name)
                    Spacer()
                    Text("\(drink.price) kr")
                }
            }
            .sheet(isPresented: $showingAddDrinkView) {
                AddDrinkView()
                    .environmentObject(drinkViewModel)
            }
            .navigationTitle("Drycker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddDrinkView = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .padding()
                    }
                }
            }
        }
    }
}

struct DrinkSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DrinkSettingsView()
    }
}
