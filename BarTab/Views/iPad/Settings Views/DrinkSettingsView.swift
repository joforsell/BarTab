//
//  DrinkSettingsView.swift
//  BarTab
//
//  Created by Johan Forsell on 2021-12-06.
//

import SwiftUI

struct DrinkSettingsView: View {
    @EnvironmentObject var drinkListVM: DrinkListViewModel
    @EnvironmentObject var userHandler: UserHandling
    
    var geometry: GeometryProxy
    @Binding var detailViewShown: DetailViewRouter
    
    @State var editMode: EditMode = .inactive
    @State private var showingAddDrinkView = false
    @State private var newPrice = ""
    @State private var currentDrinkShown: DrinkViewModel?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach($drinkListVM.drinkVMs) { $drinkVM in
                        VStack(spacing: 0) {
                            DrinkRow(drinkVM: $drinkVM, geometry: geometry)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(currentDrinkShown?.id == drinkVM.id ? Color("AppBlue") : Color.clear)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if currentDrinkShown?.id == drinkVM.id {
                                        detailViewShown = .none
                                        currentDrinkShown = nil
                                    } else {
                                        detailViewShown = .drink(drinkVM: $drinkVM, detailsViewShown: $detailViewShown)
                                        currentDrinkShown = drinkVM
                                    }
                                }
                            Divider()
                        }
                    }
                }
            }
            .padding(.top)
            .frame(width: geometry.size.width * 0.25)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showingAddDrinkView = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.accentColor)
                        .padding()
                        .frame(width: 80)
                }
                .sheet(isPresented: $showingAddDrinkView) {
                    AddDrinkView(detailViewShown: $detailViewShown)
                        .clearModalBackground()
                }
            }
        }
        .background(Color.black.opacity(0.3))
        .ignoresSafeArea(.keyboard)
    }
}

private struct DrinkRow: View {
    @EnvironmentObject var userHandler: UserHandling
    @Binding var drinkVM: DrinkViewModel
    var geometry: GeometryProxy
    
    var body: some View {
        HStack {
            Image(drinkVM.drink.image.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
                .frame(maxWidth: geometry.size.width * 0.05)
            VStack(alignment: .leading) {
                Text(drinkVM.drink.name)
                    .font(.callout)
                    .fontWeight(.bold)
                Text(Currency.display(Float(drinkVM.drink.price), with: userHandler.user))
                    .font(.footnote)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.body)
                .foregroundColor(.white.opacity(0.2))
        }
        .foregroundColor(.white)
        .frame(height: geometry.size.height * 0.05)
    }
}
