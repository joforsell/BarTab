//
//  DrinkSettingsDetailsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI
import Combine
import Introspect

struct DrinkSettingsDetailView: View {
    @EnvironmentObject var drinkListVM: DrinkListViewModel
    @Binding var drinkVM: DrinkViewModel
    var geometry: GeometryProxy
    
    @State private var editingName = false
    @State private var editingPrice = false
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 20) {
            Image("gintonic")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundColor(.accentColor)
                .padding(.top, 48)
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 22)
                    }
                    .offset(x: 40)
                }
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .bottom) {
                    TextField(drinkVM.drink.name,
                              text: $drinkVM.drink.name,
                              onEditingChanged: { editingChanged in
                        if editingChanged {
                            editingName = true
                        } else {
                            editingName = false
                        } },
                              onCommit: { editingName.toggle() }
                    )
                        .disableAutocorrection(true)
                        .font(.title3)
                    Spacer()
                }
                .offset(y: 4)
                .overlay(alignment: .trailing) {
                    Image(systemName: "square.text.square.fill")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.5)
                }
                .overlay(alignment: .topLeading) {
                    Text("Namn".uppercased())
                        .font(.caption2)
                        .foregroundColor(.white)
                        .opacity(0.5)
                        .offset(y: -10)
                }
            }
            .frame(width: 300, height: 24)
            .padding()
            .foregroundColor(.white)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(6)
            .addBorder(editingName ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
            .padding(.top, 48)

            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .bottom) {
                    TextField("\(drinkVM.drink.price) kr",
                              text: $drinkVM.priceAsString,
                              onEditingChanged: { editingChanged in
                        if editingChanged {
                            editingPrice = true
                        } else {
                            editingPrice = false
                        } }, onCommit: { editingPrice.toggle() }
                    )
                        .onReceive(Just(drinkVM.priceAsString)) { newValue in
                            let filtered = newValue.filter { "01233456789".contains($0) }
                            if filtered != newValue {
                                self.drinkVM.priceAsString = filtered
                            }
                        }
                        .font(.title3)
                    Spacer()
                }
                .offset(y: 4)
                .overlay(alignment: .trailing) {
                    Image(systemName: "dollarsign.square.fill")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.5)
                }
                .overlay(alignment: .topLeading) {
                    Text("Pris".uppercased())
                        .font(.caption2)
                        .foregroundColor(.white)
                        .opacity(0.5)
                        .offset(y: -10)
                }

            }
            .frame(width: 300, height: 24)
            .padding()
            .foregroundColor(.white)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(6)
            .addBorder(editingPrice ? .accentColor : Color.clear, width: 1, cornerRadius: 6)
            Spacer()
        }
            Spacer()
        }
    }
}

