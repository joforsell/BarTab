//
//  DrinkSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI

struct DrinkSettingsView: View {
    @EnvironmentObject var drinkListVM: DrinkListViewModel
    
    var geometry: GeometryProxy
    @Binding var detailViewShown: DetailViewRouter
    
    @State var editMode: EditMode = .inactive
    @State private var showingAddDrinkView = false
    @State private var newPrice = ""
    @State private var currentDrinkShown: DrinkViewModel?
    
    var body: some View {
        VStack {
            ForEach($drinkListVM.drinkVMs) { $drinkVM in
                VStack {
                    DrinkRow(drinkVM: $drinkVM, geometry: geometry)
                        .onTapGesture {
                            detailViewShown = .drink(drinkVM: $drinkVM, geometry: geometry)
                            currentDrinkShown = drinkVM
                        }
                    Divider()
                }
                .background(currentDrinkShown?.drink.name == drinkVM.drink.name ? Color("AppBlue") : Color.clear)
            }
            Spacer()
        }
        .frame(width: geometry.size.width * 0.15)
        .padding()
        .background(Color.black.opacity(0.3))
    }
}

struct DrinkRow: View {
    @Binding var drinkVM: DrinkViewModel
    var geometry: GeometryProxy
    
    var body: some View {
        HStack {
            Image("beer")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
                .padding(.leading)
            VStack(alignment: .leading) {
                Text(drinkVM.drink.name)
                    .font(.headline)
                    .fontWeight(.bold)
                Text("\(drinkVM.drink.price) kr")
                    .font(.caption)
            }
            .padding()
            .foregroundColor(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.body)
                .foregroundColor(.white.opacity(0.2))
        }
        .frame(height: geometry.size.height * 0.05)
    }
}
