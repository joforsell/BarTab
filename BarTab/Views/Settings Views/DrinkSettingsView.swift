//
//  DrinkSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI
import simd

struct DrinkSettingsView: View {
    @EnvironmentObject var drinkListVM: DrinkListViewModel
    
    var geometry: GeometryProxy
    
    @State var editMode: EditMode = .inactive
    @State private var showingAddDrinkView = false
    @State private var newPrice = ""
    
    var body: some View {
        VStack {
            ForEach($drinkListVM.drinkVMs) { $drinkVM in
                DrinkRow(drinkVM: $drinkVM, geometry: geometry)
            }
            Spacer()
        }
        .frame(width: geometry.size.width * 0.2)
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
            VStack {
                Text(drinkVM.drink.name)
                    .font(.headline)
                Spacer()
                Text("\(drinkVM.drink.price) kr")
                    .font(.caption)
            }
            .foregroundColor(.white)
        }
        .frame(height: geometry.size.height * 0.1)
    }
}
